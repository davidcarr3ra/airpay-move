// Hypermatter vault module
// Implements deposit, required for redemption of fiat
module hypermatter::vault {
    // how does this work? copied from https://github.com/pontem-network/liquidswap/blob/main/sources/swap/liquidity_pool.move
    // was previuosly aptos_framework::coin;
    use aptos_framework::coin::{Self, Coin};

    const MODULE_ADMIN: address = @0x7899cc9c5b8ef15605ef46adc52d004db3caa5e4b2bb64da46cb7b9363f8e934; // hard-coding for now as above does not work

    struct HypermatterVault<phantom X> has key { // will only take one type of coin (APT) for now
        coin_reserve: Coin<X>,
        fee: u64
    }
}