import { EthProvider } from "./contexts/EthContext";
import "./App.css";
import ContractComponent from "./components/ContractComponent";

function App() {
  return (
    <EthProvider>
      <div id="App">
        <div className="container">
          <ContractComponent />
        </div>
      </div>
    </EthProvider>
  );
}

export default App;
