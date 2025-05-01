import React, { useState } from 'react';
import axios from 'axios';

const App: React.FC = () => {
  const [userId, setUserId] = useState('');
  const [amount, setAmount] = useState('');
  const [response, setResponse] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await axios.post('http://order-service:3000/orders', {
        userId,
        amount: Number(amount),
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (error) {
      setResponse('Error: ' + error.message);
    }
  };

  return (
    <div>
      <h1>E-Commerce Demo</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label>User ID: </label>
          <input
            type="text"
            value={userId}
            onChange={(e) => setUserId(e.target.value)}
          />
        </div>
        <div>
          <label>Amount: </label>
          <input
            type="number"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
        </div>
        <button type="submit">Create Order</button>
      </form>
      <pre>{response}</pre>
    </div>
  );
};

export default App;