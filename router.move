// Router for Hypermatter Vault
module hypermatter::router {
    use aptos_framework::coin::{Coin, Self};
    use hypermatter::vault;

    // const MODULE_ADMIN: address = @Hypermatter;
    const MODULE_ADMIN: address = @0x7899cc9c5b8ef15605ef46adc52d004db3caa5e4b2bb64da46cb7b9363f8e934; // hard-coding for now as above does not work

    public entry fun deposit_to_vault<T>(account: &signer, amount: u64) {
        let coins = coin::withdraw<T>(account, amount);
        coin::deposit(MODULE_ADMIN, coins);
    }
}

// test via typescvript. write a function to call it.