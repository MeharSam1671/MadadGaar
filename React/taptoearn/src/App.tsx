import React, { useState } from 'react';
import markhorImage from './images/markhor.jpg'; // Import the Markhor image
import backgroundImage from './images/background.jpg'; // Import the background image
import coin from "./images/coin.png"

const MarkhorApp = () => {
  const [score, setScore] = useState(0);
  const [reward, setReward] = useState("");
  const [isClicked, setIsClicked] = useState(false);

  
  const handleTap = () => {
    setIsClicked(true);

    // Reset the click effect after 150ms to simulate a press-and-release effect
    setTimeout(() => setIsClicked(false), 150);

    setScore((prevScore) => {
      const newScore = prevScore + 1;
      // Check if user has earned a reward
      if (newScore % 100 === 0) {
        setReward('You earned a special item!');
      } else {
        setReward("");
      }
      return newScore;
    });
  };

  return (
    <div style={{
      textAlign: 'center',
      padding: '0px',
      marginTop: '-35px',


      height: '100vh', // Stretch the div to cover the full viewport height
      width: '100vw'
    }}>
      <div style={{
        backgroundColor:'#47221F',
        // Make sure the background covers the entire div
        backgroundPosition: 'center', height: '120vh', // Stretch the div to cover the full viewport height
        width: '100vw'
      }}>
        <h1 style={{ color: "white", paddingTop: '2rem',  textShadow: '2px 2px 5px rgba(0.5, 0, 0.5, 0.9)' }}>Markhor</h1>
        <div style={{
  display: 'grid', 
  gridTemplateColumns: '1fr 1fr', // Creates 2 equal columns
  gridTemplateRows: '1fr 1fr',    // Creates 2 equal rows
  gap: '2px',                    // Adds spacing between the grid items
  width: '100vw',                 // Set width of the grid
  height: '1vh',  
  marginBottom:'5rem'              // Set height of the grid
}}>
  <div style={{ backgroundColor: 'lightblue', textAlign: 'center',padding:'1rem' }}><b>Level</b></div>
  <div style={{ backgroundColor: 'lightcoral', textAlign: 'center',padding:'1rem' }}><b>Community</b></div>
  <div style={{ backgroundColor: 'lightgreen', textAlign: 'center' }}>1</div>
  <div style={{ backgroundColor: 'lightpink', textAlign: 'center' }}>None</div>
</div>

        <p style={{
  
  color: 'white', 
  fontSize: '30px', 
  textSizeAdjust: '100%' 
}}>
  <img 
    src={coin} 
    style={{ 
      height: "2.5rem", 
      borderRadius: '200rem',
      paddingRight: '0.5rem',
      display: 'inline-block', // Ensure the image is inline
      verticalAlign: 'middle' // Align image with the text
    }} 
    alt="" 
  />
  <span style={{ display: 'inline-block', verticalAlign: 'middle',textShadow: '2px 2px 5px rgba(0.5, 0, 0.5, 0.9)' }}>
    {score}
  </span>
</p>


        <button
          onClick={handleTap}
          style={{
            padding: '10px 20px',

            fontSize: '16px',
            borderRadius: '50rem',
            height: '20rem',
            width: '20rem',

            backgroundImage: `url(${markhorImage})`, // Set the Markhor image on the button
            backgroundSize: 'cover', // Ensure the image covers the button fully
            backgroundPosition: 'center',
            boxShadow: '0 10px 20px rgba(0, 0, 0, 6.9)', // Add shadow to the button
            border: isClicked ? 'none' : 'none', // Show border when isClicked is true
            transform: isClicked ? 'scale(0.9)' : 'scale(1)', // Shrink on click and revert back
            transition: 'transform 0.1s ease, background 0.1s ease', // Smooth transition
          }}
        >
        </button>
        {reward && <p style={{ color: 'green', fontWeight: 'bold' }}>{reward}</p>}
      </div></div>
  );
};

export default MarkhorApp;
