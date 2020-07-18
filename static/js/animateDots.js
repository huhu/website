(() => {
  const possibleValues = [0.2, 0.4, 0.6, 0.7, 1];
  const weights = [0.03, 0.2, 0.15, 0.07, 0.55];

  function getRandom() {
    const num = Math.random();
    let sum = 0;
    let lastIndex = weights.length - 1;

    for (let i = 0; i < lastIndex; ++i) {
      sum += weights[i];
      if (num < sum) {
        return possibleValues[i];
      }
    }

    return possibleValues[lastIndex];
  }

  const dotsContainer = document.querySelector(".dots");
  for (let i = 0; i < 49; i++) {
    const dot = document.createElement("div");
    dot.className = "dot";
    dot.style.opacity = getRandom();
    dotsContainer.appendChild(dot);
  }

  setInterval(() => {
    dotsContainer.querySelectorAll(".dot").forEach(dot => {
      dot.style.opacity = getRandom();
    });
  }, 750);
})();
