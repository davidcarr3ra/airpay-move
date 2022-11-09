script {
    use aptos_framework::coin::{Self, Coin};
    use hypermatter::router;
    use aptos_framework::aptos_coin::AptosCoin;

    fun run_hypermatter(account: &signer, amount: u64) {
        router::deposit_to_vault<Coin<AptosCoin>>(account, amount);
    }
}