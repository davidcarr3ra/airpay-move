// Router for Hypermatter Vault
module hypermatter::router {
    use aptos_framework::coin::{Coin, Self};
    use hypermatter::vault;

    // const MODULE_ADMIN: address = @Hypermatter;
    const VAULT_PLACEHOLDER: address = @0xf2fb6d07c5e1efc5e4bbd1dd08c34b4b6a994c10b9558ac50954211bf62d418d; // hard-coding for now as above does not work

    public entry fun deposit_to_vault<T>(account: &signer, amount: u64) {
        let coins = coin::withdraw<T>(account, amount); // note: account must be registered with cointype T
        coin::deposit(VAULT_PLACEHOLDER, coins); // note: account must be registered with cointype T
    }
}