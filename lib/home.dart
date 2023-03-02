import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollster/link_smart_contract.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<LinkSmartContract>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          child: Text("A"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Total Votes: ${contractLink.votesA ?? ""}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const CircleAvatar(
                          child: Text("B"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Total Votes: ${contractLink.votesB ?? ""}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      contractLink.voteAlpha();
                    },
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('Vote Alpha'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      contractLink.voteBeta();
                    },
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('Vote Beta'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
