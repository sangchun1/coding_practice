const currentTime = new Date();
if (currentTime.getHours() < 12) {
    console.log(`${currentTime.toLocaleString()}은/는 오전입니다.\n`);
} else {
    console.log(`${currentTime.toLocaleString()}은/는 오후입니다.\n`);
}

const amPm = currentTime.getHours() < 12 ? '오전' : '오후';
console.log(`${currentTime.toLocaleString()}은/는 {amPm}입니다.\n`);