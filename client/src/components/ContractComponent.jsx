import { useState } from "react";
import useEth from "../contexts/EthContext/useEth";

function ContractComponent({ setValue }) {
  const {
    state: { contract, accounts },
  } = useEth();
  const [inputValue, setInputValue] = useState("");

  const btnClicked = () => {
    console.log("button clicked");
  };

  // const read = async () => {
  //   btnClicked();
  //   const value = await contract.methods.read().call({ from: accounts[0] });
  //   setInputValue(value);
  // };

  // const inc = async () => {
  //   btnClicked();
  //   await contract.methods.inc().send({ from: accounts[0] });
  // };

  // const addTodo = async () => {
  //   btnClicked();
  //   await contract.methods.addTodo("todos ...").send({ from: accounts[0] });
  // };

  // const getTodos = async () => {
  //   btnClicked();
  //   const todos = await contract.methods.getTodos().call({ from: accounts[0] });
  //   console.log(todos);
  // };

  const createEvent = async () => {
    btnClicked();
    const event = await contract.methods
      .createEvent(
        "Sample Event",
        "Desc.",
        "1668253458",
        "2000000000000000000",
        "20"
      )
      .send({ from: accounts[0] });

    console.log(event);
  };

  const events = async () => {
    btnClicked();
    const event = await contract.methods.events(0).call({ from: accounts[0] });

    console.log(event);
  };

  return (
    <div className="btns">
      {/* <button onClick={addTodo}>add todo()</button>

      <button onClick={getTodos}>getTodos()</button>

      <button onClick={read}>read()</button>

      <button onClick={inc}>inc()</button> */}

      <button onClick={createEvent}>createEvent()</button>
      <button onClick={events}>getEvent(0)</button>

      <div className="input-btn">
        here result: {accounts && accounts[0]} {inputValue}
      </div>
    </div>
  );
}

export default ContractComponent;
