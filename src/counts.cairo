/// Interface representing `HelloContract`.
/// This interface allows modification and retrieval of the contract balance.
#[starknet::interface]
pub trait IHelloStarknet<TContractState> {
    /// Increase contract balance.
    fn increase_balance(ref self: TContractState, amount: felt252);
    /// Decrease contract balance.
    fn decrease_balance(ref self: TContractState, amount: felt252);
    /// Retrieve contract balance.
    fn get_balance(self: @TContractState) -> felt252;
}

/// Simple contract for managing balance.
#[starknet::contract]
pub mod HelloStarknet {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{ContractAddress, get_caller_address, contract_address_const};

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[event]
    #[derive(Drop, Copy, starknet::Event)]
    enum Event {
        BalanceIncrease: BalanceIncrease,
        BalanceDecrease: BalanceDecrease,
    }

    #[derive(Drop, Copy, starknet::Event)]
    struct BalanceIncrease {
        caller: ContractAddress,
        amount: felt252,
    }

    #[derive(Drop, Copy, starknet::Event)]
    struct BalanceDecrease {
        caller: ContractAddress,
        amount: felt252,
    }

    #[abi(embed_v0)]
    impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            let caller = get_caller_address();
            let zero_add = contract_address_const::<0>();
            assert(caller != zero_add, 'caller cannot be zero address');
            self.balance.write(self.balance.read() + amount);
        }

        fn decrease_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            let caller = get_caller_address();
            let zero_add = contract_address_const::<0>();
            assert(caller != zero_add, 'caller cannot be zero address');
            self.balance.write(self.balance.read() - amount)
        }

        fn get_balance(self: @ContractState) -> felt252 {
            let caller = get_caller_address();
            let zero_add = contract_address_const::<0>();
            assert(caller != zero_add, 'caller cannot be zero address');
            self.balance.read()
        }
    }
}

