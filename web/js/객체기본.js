// 배열 - 객체
let arrayPersonInfo = ["제임스", 28, "남자"];

// 딕셔너리 - 객체
let personalInfo = {
  name: "제임스",
  age: "28",
  gender: "남자",
};
console.log(personalInfo["name"]);
// 제임스

// let maria = {name : '마리아', age : 24, gender : '여자'};
console.log(maria.age);

// key 값을 변수(문자열)로 받는 경우
const key = "age";
// maria.key 와 같이 사용하면 안됨
console.log(maria[key], maria["gen" + "der"]);

// for 반복문을 사용해서 key value 가져오기
const maria = { name: "마리아", age: 24, gender: "여자" };
for (let key in maria) {
  console.log(key, maria[key]);
}
const james = { name: "제임스", age: 28, gender: "남자" };
const persons = [maria, james];
for (let person of persons) {
  for (let key in person) {
    console.log(key, person[key]);
  }
}

// 객체 안에 사용되는 함수를 method라 함
// 객체 : 속성(property, attribute) + method

const maria2 = {
  name: "마리아",
  age: 24,
  gender: "여자",
  intro: function () {
    console.log(
      `저는 ${this.name}이고, 나이는 ${this.age}이며, ${this.gender}입니다.`
    );
  },
};
console.log(maria2);
maria2.intro();

const james2 = {
  name: "제임스",
  age: 28,
  gender: "남자",
  intro: function () {
    console.log(
      `저는 ${this.name}이고, 나이는 ${this.age}이며, ${this.gender}입니다.`
    );
  },
};
james2.intro();

// prototype - 옛날 javascript에서 제공하는 방법
// 파이썬에서 Class를 만드는 방식과 유사
function Person(name, age, gender) {
  this.name = name;
  this.age = age;
  this.gender = gender;

  Person.prototype.intro = function () {
    console.log(
      `저는 ${this.name}이고, 나이는 ${this.age}이며, ${this.gender}입니다.`
    );
  };
}
var james3 = new Person("제임스", -1, "남자");
var maria3 = new Person("마리아", 24, "여자");
james3.intro();
maria3.intro();

// 지금 클래스를 사용해서 객체를 찍어내는 틀 만들기
class Person2 {}

class Person3 {
  constructor(name = "홍길동", age = 25, gender = "남자") {
    this.name = name;
    this.age = age;
    this.gender = gender;
  }
  toString() {
    return `저는 ${this.name}이고, 나이는 ${this.age}이며, ${this.gender}입니다.`;
  }
}

// 자식 클래스
class Students extends Person3 {
  constructor(name, age, gender, scholarship = 100000) {
    super(name, age, gender);
    this.scholarship = scholarship;
  }
  toString() {
    return super.toString() + `\n 장학금은 ${this.scholarship}원을 받았습니다.`;
  }
}
// Teacher 클래스 = Person3를 상속, 속성 담당부서를 추가, toString()메소드 재정의

class Teacher extends Person3 {
  constructor(name, age, gender, dept) {
    super(name, age, gender);
    this.dept = dept;
  }

  toString() {
    return super.toString() + `\n담당반은 ${this.dept}입니다.`;
  }
}

const teacher = new Teacher("제임스", 40, "남자", "JS-B반");
teacher.toString();

// 문제 : 장바구니
// Product 클래스 정의 (속성: 이름, 가격, 메소드 toString())
// 5가지 상품을 만듬(instance)
// toString return 값이 제품명 : 000, 가격 : 0000

// Cart 클래스 정의 (속성: 상품, 수량, 메소드: add(), sum())
// Cart에 물건을 다 담은 후 총 가격을 구하세요

class Product {
  constructor(name, price) {
    this.name = name;
    this.price = price;
  }

  toString() {
    return `제품명 : ${this.name}, 가격 : ${this.price}원`;
  }
}
const mouse = new Product("mouse", 3000);
const monitor = new Product("monitor", 200000);
const keyboard = new Product("keyboard", 20000);
const headset = new Product("headset", 35000);
const usb = new Product("usb", 15000);

class Cart {
  constructor() {
    this.cart = [];
  }

  add(product, quantity) {
    if (quantity <= 0) {
      return;
    }
    this.cart.push({ product, quantity });
  }

  sum() {
    let totalprice = 0;
    for (let item of this.cart) {
      totalPrice += item.quantity * item.product.price;
    }
    return totalPrice;
  }

  toString() {
    let result = ``;
    for (let item of this.cart) {
      result += item.product.toString() + `\t 수량 : ${item.quantity}`;
    }
    result += `합계 : ${this.sum()}`;
    return result;
  }
}
let cart = new Cart();
cart.add(mouse, 4);
cart.add(usb, 10);
cart.add(monitor, 2);
console.log(cart.toString());
