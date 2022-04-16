/*
 * Custom functions used to communicate with the wallet
 * 
 * browserify index.js --standalone trezor > app.js
 *
 * TODO: Figure out why signing testnet transactions is not working correctly (change address is different) 
 */

let bitcoin = require('bitcoinjs-lib');


// Handle setting the currency network 
function setCurrency(net='mainnet'){
    var network = (net=='testnet') ? 'Testnet' : 'Bitcoin';
    console.log('setCurrency network=',network);
    TrezorConnect.setCurrency(network);
}

// Handle requesting a xpubkey from the Trezor
function getXpubkey(net='mainnet', callback){
    setCurrency(net);
    TrezorConnect.getXPubKey(null, function(response){
        if(typeof callback === 'function')
            callback(response);
    });    
}

// Handle requesting a list of addresses 
function getAddressesFromXpub(net='mainnet', xpubkey,  limit=10, start=0){
    var network = (net=='testnet') ? 'testnet' : 'mainnet';
    const node = bitcoin.HDNode.fromBase58(xpubkey, bitcoin.networks[network]).neutered();
    addresses = [];
    var stop = start + limit;
    for(var i = start; i < stop; i++) {
        var address = node.derive(0).derive(i).getAddress();
        addresses.push(address);
    }
    return addresses;
}

// Handle validating that a signed tx outputs match the unsigned tx outputs
function isValidTransaction(unsignedTx, signedTx){
    var u = bitcoin.Transaction.fromHex(unsignedTx), // Unsigned
        s = bitcoin.Transaction.fromHex(signedTx);   // Signed
        v = true; // valid (true/false)
    // make sure outputs and values matches unsigned transaction
    s.outs.forEach(function(out, n){
        var a = bitcoin.script.toASM(u.outs[n].script),
            b = bitcoin.script.toASM(s.outs[n].script);
        console.log('Unsigned output, value=', a, u.outs[n].value);
        console.log('Signed   output, value=', b, s.outs[n].value);
        // Error if outputs or values do not match
        if(a!=b || u.outs[n].value!=s.outs[n].value)
            v = false;
    });
    return v;
}

// Handle signing a transaction
// @net        = Network (mainnet, testnet)
// @source     = Source Address
// @path       = BIP44 Path (https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki)
// @unsignedTx = Unsigned Transaction in hex format
// @callback   = Callback function
function signTx(net='mainnet', source, path, unsignedTx, callback){
    console.log('signTx net, source, path, unsignedTx=', net, source, path, unsignedTx);
    var inputs  = [],
        outputs = [],
        network = (net=='testnet') ? '0x80000001' : '0x80000000', // default to mainnet
        api_net = (net=='testnet') ? 'tbtc' : 'btc',
        tx      = bitcoin.Transaction.fromHex(unsignedTx),
        utxos   = {}; // object containing utxo hashes and specific output indexes to use
    // Convert BIP44 path into usable Trezor address_n
    var bip44   = path.split("'/"); // m / purpose' / coin_type' / account' / change / address_index
        address = [bip44[0] | network, bip44[1] | network, bip44[2] | network, bip44[3], bip44[4]];
    // Loop through inputs and get list of previous transaction hashes
    tx.ins.forEach(function(input, n){
        var tx_hash = input.hash.reverse().toString('hex');
        utxos[tx_hash] = -1; // set to -1 so we can determine which ones have been processed and which have not
    });
    // Define callback to run when done with API calls 
    var doneCb = function(){
        // Check if we are truly done
        var done = true;
        for(var tx_hash in utxos){
            if(utxos[tx_hash]==-1)
                done = false;
        }
        if(done){
            // Build out a list of inputs
            tx.ins.forEach(function(input, n){
                var tx_hash = input.hash.toString('hex'); // no need to reverse since it was already done above
                inputs.push({
                    address_n: address,         // Address 
                    prev_hash: tx_hash,         // Previous transaction hash
                    prev_index: utxos[tx_hash]  // output to use from previous transaction
                })
            });
            // Build out a list of outputs
            tx.outs.forEach(function(out, n){
                var asm = bitcoin.script.toASM(out.script),
                    output = {};
                if(/^OP_RETURN/.test(asm)){
                    output = {
                        script_type: 'PAYTOOPRETURN',
                        amount: 0,
                        op_return_data: String(asm).replace('OP_RETURN ','')
                    };
                } else {
                    output = {
                        script_type: 'PAYTOADDRESS',
                        address_n: address,
                        amount: out.value
                    }
                }
                outputs.push(output);
            });
            console.log('inputs=',inputs);
            console.log('outputs=',outputs);
            setCurrency(net);
            TrezorConnect.signTx(inputs, outputs, function(data){
                console.log('data=',data);
                // If the outputs mismatch in any way, the tx is not what is expected and we should throw error
                // This can happen if user entered wrong/different password.
                if(data.serialized_tx && !isValidTransaction(unsignedTx, data.serialized_tx)){
                    var data = {
                        success: false,
                        error: 'outputs mismatch'
                    };
                }
                if(typeof callback === 'function')
                    callback(data);
            });
        }
    };
    // Request info on the utxos being used in this transaction and determine what output from the previous transaction is being used
    for(var tx_hash in utxos){
        $.getJSON('https://api.blocktrail.com/v1/' + api_net + '/transaction/' + tx_hash + '?api_key=781fc8d6bc5fc6a83334384eecd8c9917d5baf37', function(data){
            var index = 0;
            if(data){
                data.outputs.forEach(function(input, idx){
                    if(input.address==source)
                        index = idx;
                });
            }
            utxos[tx_hash] = index;
            doneCb();
        });
    }
}


// Broadcast a given transaction
// @net      = Network (mainnet, testnet)
// @signedTx = Signed Transaction in hex format
// @callback = Callback function
function broadcastTx(network, signedTx, callback){
    var net  = (network=='testnet') ? 'UNOTEST' : 'UNO',
        host = (network=='testnet') ? 'unoparty-testnet.xchain.io' : 'unoparty.xchain.io';
    // First try to broadcast using the XChain API
    $.ajax({
        type: "POST",
        url: 'https://' + host +  '/api/send_tx',
        data: { 
            tx_hex: signedTx 
        },
        complete: function(o){
            // console.log('o=',o);
            // Handle successfull broadcast
            if(o.responseJSON.tx_hash){
                var txid = o.responseJSON.tx_hash;
                if(callback)
                    callback(txid);
                if(txid)
                    console.log('Broadcasted transaction hash=',txid);
            } else {
                // If the request to XChain API failed, fallback to chain.so API
                $.ajax({
                    type: "POST",
                    url: 'https://chain.so/api/v2/send_tx/' + net,
                    data: { 
                        tx_hex: signedTx 
                    },
                    dataType: 'json',
                    complete: function(o){
                        // console.log('o=',o);
                        if(o.responseJSON.data && o.responseJSON.data.txid){
                            var txid = o.responseJSON.data.txid;
                            if(callback)
                                callback(txid);
                            if(txid)
                                console.log('Broadcast transaction tx_hash=',txid);
                        } else {
                            cbError('Error while trying to broadcast signed transaction',callback);
                        }
                    }
                });                
            }
        }
    });
}


module.exports = {
    getXpubkey,
    getAddressesFromXpub,
    signTx,
    broadcastTx
}
