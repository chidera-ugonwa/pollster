pragma solidity ^0.8.14;

contract Voting{

int alpha;
int beta;

constructor()  {
   alpha  = 0;
    beta = 0;
}

function getTotalVotesAlpha() view public returns(int) {
    return alpha;
}

function getTotalVotesBeta() view public returns(int){
    return beta;
}

function voteAlpha () public{
    alpha = alpha+1;
}

function voteBeta () public{
    beta = beta+1;
}
}