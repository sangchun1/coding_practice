function getScore() {
  const num = parseInt(document.getElementById("score").value);
  let grade;

  switch (parseInt(score / 10)) {
    case 10:
    case 9:
      grade = "A";
      break;
    case 8:
      grade = "B";
      break;
    case 7:
      grade = "C";
      break;
    case 6:
      grade = "D";
      break;
    default:
      grade = "F";
      break;
  }
  document.getElementById("p1").innerHTML = `${score}점은 ${grade}학점입니다.`;
}
