// use starknet::ContractAddress;

// use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
// use count_deploy::counts::{
//     IHelloStarknetSafeDispatcher,
//     IHelloStarknetSafeDispatcherTrait,
//     IHelloStarknetDispatcher,
//     IHelloStarknetDispatcherTrait
// };

// fn deploy_contract(name: ByteArray) -> ContractAddress {
//     let contract = declare(name).unwrap().contract_class();
//     let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
//     contract_address
// }

// #[test]
// fn test_increase_balance() {
//     let contract_address = deploy_contract("HelloStarknet");

//     let dispatcher = IHelloStarknetDispatcher { contract_address };

//     let balance_before = dispatcher.get_balance();
//     assert(balance_before == 0, 'Invalid balance');

//     dispatcher.increase_balance(42);

//     let balance_after = dispatcher.get_balance();
//     assert(balance_after == 42, 'Invalid balance');
// }

// #[test]
// #[feature("safe_dispatcher")]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract("HelloStarknet");

//     let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         },
//     };
// }

//luke combs

use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use count_deploy::counts::{
    IHelloStarknetDispatcher, IHelloStarknetDispatcherTrait, IHelloStarknetSafeDispatcher,
    IHelloStarknetSafeDispatcherTrait,
};

// deploy helper function
fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_increase_count() {
    let contract_address = deploy_contract("HelloStarknet");

    let dispatcher = IHelloStarknetDispatcher { contract_address };

    let current_balance = dispatcher.get_balance();
    assert(current_balance == 0, 'current balance must be zero');
    dispatcher.increase_balance(90);
    let new_balance = dispatcher.get_balance();
    assert(new_balance == 90, 'invalid new balance')
}

#[test]
fn test_invalid_increase_count_with_0() {
    let contract_address = deploy_contract("HelloStarknet");

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();

    assert(balance_before == 0, 'Balance not zero');

    match safe_dispatcher.increase_balance(0) {
        Result::Ok(_) => core::panic_with_felt252('should have panicked'),
        Result::Err(panic_data) => {
            //ensure the panic error message is same as the error message in the conteract

            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0))
        },
    };
}

#[test]
fn test_decrease_count() {
    let contract_address = deploy_contract("HelloStarknet");

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'invalid balance before');
    //call the decrease count method to decrease count

    match safe_dispatcher.increase_balance(10) {
        Result::Ok(()) => {
            // assert(result == 10, 'balance should be 10');

            let balance_after = safe_dispatcher.get_balance().unwrap();
            assert(balance_after == 10, 'balance not updated correctly')
        },
        Result::Err(_) => { panic!("increase balance should succeed") },
    }

    match safe_dispatcher.decrease_balance(5) {
        Result::Ok(()) => {
            let current_balance = safe_dispatcher.get_balance().unwrap();
            assert(current_balance == 5, 'invalid balance');
        },
        Result::Err(_) => { core::panic_with_felt252('decrease balance should succeed') },
    }
}

#[test]
fn test_retrieve_count() {
    let contract_address = deploy_contract("HelloStarknet");

    let dispatcher = IHelloStarknetDispatcher { contract_address };

    let current_balance = dispatcher.get_balance();
    assert(current_balance == 0, 'balance must be zero');
}
