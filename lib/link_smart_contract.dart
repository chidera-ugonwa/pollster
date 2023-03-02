import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:web_socket_channel/io.dart';

class LinkSmartContract extends ChangeNotifier {
  final String _rpcURl = "http://127.0.0.1:7545";
  final String _wsURl = "ws://127.0.0.1:7545/";
  final String _privateKey =
      "826dd2cc184b2acb67dcc11c9e29d3dafcde0fb3931f2aeba0c334d4d41eda29";

  //it's used to establish a connection to the Ethereum RPC node with the help of WebSocket
  late Web3Client _client;
  //it's used to read the contract ABI
  late String _abiCode;
  //it's the contract address of the deployed smart contract
  late EthereumAddress _contractAddress;
  //it's the credentials of the smart contract deployer
  late Credentials _credentials;
  //it's used to tell Web3dart where the contract is declared
  late DeployedContract _contract;
  //it's the function that is declared in our SmartContract
  late ContractFunction _voteAlpha;
  late ContractFunction _voteBeta;
  late ContractFunction _getTotalVotesAlpha;
  late ContractFunction _getTotalVotesBeta;

  //it's used to check the contract state
  bool isLoading = true;
  //it's the votes from the smart contract
  var votesA;
  var votesB;

  LinkSmartContract() {
    initialize();
  }
  //define initialize
  initialize() async {
    // establish a connection to the Ethereum RPC node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcURl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsURl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/Voting.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    // print(_credentials);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);

    // Extracting the functions, declared in contract.
    _voteAlpha = _contract.function("voteAlpha");
    _voteBeta = _contract.function("voteBeta");
    _getTotalVotesAlpha = _contract.function("getTotalVotesAlpha");
    _getTotalVotesBeta = _contract.function("getTotalVotesBeta");
    getVotes();
  }

  Future<void> getVotes() async {
    // Getting the current name declared in the smart contract.
    var votesAlpha = await _client
        .call(contract: _contract, function: _getTotalVotesAlpha, params: []);
    var votesBeta = await _client
        .call(contract: _contract, function: _getTotalVotesBeta, params: []);

    votesA = votesAlpha[0];
    votesB = votesBeta[0];
    isLoading = false;
    notifyListeners();
  }

  Future<void> voteAlpha() async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _voteAlpha,
          parameters: [],
        ));
    getVotes();
  }

  Future<void> voteBeta() async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _voteBeta,
          parameters: [],
        ));
    getVotes();
  }
}
