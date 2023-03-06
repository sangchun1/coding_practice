// Number
let number = 273.1;
let num = Number("273.1");
console.log(num === number); // 두가지 방법이 동일

// 객체의 자료형
let obj = new Number(273.1);
console.log(typeof number, typeof num, typeof obj);
// number number object

let pi = Math.PI;
console.log(pi);
console.log(pi.toExponential()); //지수형태
console.log(pi.toFixed()); // 소수점 이하 자리수가 2개
console.log(pi.toPrecision()); // 유효숫자가 6개

console.log(Math.pow(2, 53) - 1); // 9007199254740991

// String
let hello = "안녕하세요?"; // literal 생성
let helloFromConstructor = new String("안녕하세요?"); // 생성자 함수로 생성

console.log(hello.length); // 6글자
// method
console.log(hello.charAt(1)); // hello[1]
console.log(hello.concat("여러분!!!")); // hello + "여러분!!!"
console.log(hello.indexOf("하"), hello.indexOf("한")); // 2, -1

// 문제
// 디지털 시계 (00:00 ~ 23:59)가 있다
// 디지털 시계에서 3이라는 숫자가 표시되는 시간은 하루에 총 몇초인가?
let totalSeconds = 0;

for (let h = 0; h < 24; h++) {
  for (let m = 0; m < 60; m++) {
    let d = String(h) + ":" + String(m);
    if (d.indexOf("3") >= 0) {
      totalSeconds += 60;
    }
  }
}
console.log(totalSeconds);

// 정규표현식(Regular Expression)
let sample = "A quick brown for 갈색의 재빠른 여우가 over the lazy dog";
let newStr = sample.replace(/[A-Z]/, " ");
console.log(newStr); // quick brown for 갈색의 재빠른 여우가 over the lazy dog
newStr = sample.replace(/r/g, "R");
console.log(newStr); // A quick bRown foR 갈색의 재빠른 여우가 oveR the lazy dog
newStr = sample.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g, "");
console.log(newStr); // A quick brown for    over the lazy dog

// 문자열 일부분 추출
let str = "Apple, Banana, Kiwi";
console.log(str.slice(7, 7 + 6)); // Banana (시작인덱스, 끝인덱스)
console.log(str.slice(7)); // Banana, Kiwi (시작인덱스 ~ 끝)
console.log(str.substring(7, 13)); // Banana (시작인덱스, 끝인덱스)

const fruits = str.split(",");
console.log(fruits); // ['Apple', ' Banana', ' Kiwi']

// 문제
// 1에서 1000까지 숫자 중에서 0은 몇번 1은 몇번 .... 9는 몇번 나오는지
let numbers = "";
for (let i = 1; i <= 1000; i++) {
  numbers += String(i);
}

let obj1 = {};
for (let i = 0; i < 10; i++) {
  obj1[String(i)] = numbers.split(String(i)).length - 1;
}
console.log(obj1);

// Date 객체
let today = new Date();
console.log(today.toDateString()); // 날짜, 요일
console.log(today.toLocaleDateString()); // Timezone을 반영한 현재시간

// 23-01-10 13:10:00 함수로 만들기
function myLocalTimeFormat(date) {
  let year = String(date.getFullYear()).substring(2); // 2023 -> 23
  let month = String(date.getMonth() + 1);
  month = month.length == 1 ? "0" + month : month; // 9 -> 09
  let day = `${date.getDate() < 10 ? "0" + date.getDate() : date.getDate()}`;
  let hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
  let minute = `${
    date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()
  }`;
  let sec = `${
    date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds()
  }`;
  return `${year}-${month}-${day} ${hour}:${minute}:${sec}`;
}
console.log(myLocalTimeFormat(today));

// 문자열로 생성
const strDate = new Date("2022-09-14");
console.log(myLocalTimeFormat(strDate));

// 시간 요소로 생성
const elementDate = new Date(2022, 9 - 1, 14, 9, 50); // 월은 1을 빼줘야함
console.log(elementDate);
console.log(myLocalTimeFormat(elementDate));

// 시간 간격
const examDay = new Date("2023-11-16");
today = new Date("2023-01-10");
const diff = examDay.getTime() - today.getTime();
const dDay = diff / (1000 * 60 * 60 * 24);
console.log(`오늘은 수능 D-${dDay}일입니다.`);

// Array 생성
const car = ["Saab", "Volvo", "BMW"];
const persons = new Array("James", "Maria");

// Array 속성
console.log(car.length, persons.length);
console.log(car[car.length - 1]);

// 배열 합치기
console.log(car.concat(persons));
console.log(car + persons);
console.log([car, persons]);

// 문자열 만들기(join)
console.log(car.join(" | ")); // Saab | Volvo | BMW

// 마지막 요소 제거 (pop) - 배열이 변환
let car1 = car.pop();
console.log(car1);

// 마지막 요소 추가(push) - 배열이 변환
car.push("Benz");
console.log(car);

// 배열의 요소 순서를 뒤집기(reverse) - 배열이 변환
console.log(car.reverse());
console.log(car); // B, V, S

// 배열의 요소를 정렬(sort) - 배열이 변환
console.log(car); // B V S
car.sort();
console.log(car); // B S V

// 내림차순정렬
const number3 = [45, 67, 53, 97, 82];
number3.sort().reverse();
console.log(number3);
