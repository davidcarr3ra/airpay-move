module hypermatter::vault {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::AptosCoin;
    use std::signer;
    const VAULT_PLACEHOLDER: address = @0x31a2a89de4424dee90c567bc83527dba9d5a485daeb2400a18c690a3aa868f2f; // hard-coding for now as above does not work



    const ECOIN_NOT_REGISTERED: u64 = 1;
    const EVAULT_ALREADY_MOVED: u64 = 2;
    const BALANCE_NOT_ENOUGHT: u64 = 4;
    // const ESCROW_PAUSED: u64 = 5;
    const INVALIED_ADMIN: u64 = 6;

    struct Vault <T> has key {
        // T = Coin<AptosCoin>
        vault: T
        // I Don't know why pause
        // paused: bool
    }

    public(script) fun init_vault<T>(admin: &signer) {

        let addr = signer::address_of(admin);
        assert!(coin::is_account_registered<Coin<AptosCoin>>(addr), ECOIN_NOT_REGISTERED);
        assert!(!exists<Vault<T>>(addr), EVAULT_ALREADY_MOVED);
        let vault = coin::zero<AptosCoin>();
        move_to(admin, Vault {
            vault
            // I Don't know why pause
            // paused: false
        });
    }




    public(script) fun deposit <T>(user: &signer, amount: u64, custodian_account: address) acquires Vault {
        // assert!(!*&borrow_global<Vault>(custodian_account).paused, ESCROW_PAUSED);

        let addr = signer::address_of(user);
        assert!(coin::is_account_registered<Coin<AptosCoin>>(addr), ECOIN_NOT_REGISTERED);

        // Check if vault has enough money to be withdrawn
        let account_balance_value = coin::balance<Coin<T>>(addr);
        assert!(amount <= account_balance_value, BALANCE_NOT_ENOUGHT);
        let coin = coin::withdraw<Coin<AptosCoin>>(user, amount);
        let custodian = &mut borrow_global_mut<Vault<T>>(custodian_account);
        coin::merge<Coin<AptosCoin>>( custodian.vault, coin);
    }





    public(script) fun withdraw<T>(admin: &signer, amount: u64, custodian_account: address) acquires Vault {
        // T = Coin<AptosCoin>

        // I Don't know why pause
        // assert!(!*&borrow_global<Vault>(custodian_account).paused, ESCROW_PAUSED);

        let addr = signer::address_of(admin);
        // Check if the user withdrawing from the vault is the admin
        assert!(exists<Vault<T>>(addr), INVALIED_ADMIN);

        // Check if coin can be stored in an account
        assert!(coin::is_account_registered<T>(addr), ECOIN_NOT_REGISTERED);


        //Get the vault from the admin  account
        let custodian = &borrow_global_mut<Vault<T>>(custodian_account);

        // Check if vault has enough money to be withdrawn
        assert!(amount <= custodian.vault.value, BALANCE_NOT_ENOUGHT);

        //Get the coins from the vault
        let coins = coin::extract<T>(&mut custodian.vault, amount);
        //Deposit the coins into the users account
        coin::deposit<T>(addr, coins);
    }
}


