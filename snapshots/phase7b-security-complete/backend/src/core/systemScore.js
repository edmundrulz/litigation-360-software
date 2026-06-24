let errors = 0;

function recordError() {
  errors++;
}

function getScore() {

  let score = 100;

  score -= errors * 5;

  if (score < 0) score = 0;

  return {
    score,
    status:
      score > 80 ? "HEALTHY" :
      score > 50 ? "WARNING" :
      "CRITICAL"
  };
}

module.exports = { recordError, getScore };