let sum = 0;
for (let i = 0; i <= 100; i++) {
  sum += i;
}
console.log("1부터 100까지 합은 " + sum);

sum = 0;
for (let i = 1; i <= 100; i += 2) {
  sum += i;
}
console.log("1부터 100까지 홀수의 합은 " + sum);

sum = 0;
for (let i = 2; i <= 100; i += 2) {
  sum += i;
}
console.log("1부터 100까지 짝수의 합은 " + sum);

product = 1;
for (let i = 10; i > 0; i--) {
  product *= i;
}
console.log("10!은 " + product);

let j = 0;
sum = 0;
while (sum < 1000) {
  j++;
  sum += j;
}
console.log("1에서 " + j + "까지 더해야 1000이 초과됨(" + sum + ")");

let k;
sum = 0;
for (k = 0; sum < 1000; k++) {
  sum += k;
}
console.log("1에서 " + (k - 1) + "까지 더해야 1000이 초과됨(" + sum + ")");

for (let b = 1; b < 1000; b++) {
  for (let a = 1; a < b; a++) {
    c = 1000 - a - b;
    if (a * a + b * b == c * c) {
      console.log(a, b, c);
      break;
    }
  }
}
