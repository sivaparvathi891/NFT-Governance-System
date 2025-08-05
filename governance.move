module paru_addr::Governance {
  use std::vector;
  use std::signer;

  struct State has key {
    proposals: vector<vector<u8>>,
    votes: vector<u64>,
    voted: vector<address>,
    collection: address
  }

  public fun initialize(owner: &signer, nft_collection: address) {
    move_to(owner, State {
      proposals: vector::empty(),
      votes: vector::empty(),
      voted: vector::empty(),
      collection: nft_collection
    });
  }

    public fun create_proposal(owner: &signer, desc: vector<u8>) acquires State {
    let st = borrow_global_mut<State>(signer::address_of(owner));
    vector::push_back(&mut st.proposals, desc);
    vector::push_back(&mut st.votes, 0);
  }

  public fun vote(voter: &signer, creator: address, idx: u64) acquires State {
    let st = borrow_global_mut<State>(creator);
    let voter_addr = signer::address_of(voter);

    assert!(!vector::contains(&st.voted, &voter_addr), 1);
    vector::push_back(&mut st.voted, voter_addr);
    st.votes[idx] = st.votes[idx] + 1;
  }
} 