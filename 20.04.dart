const EventEmitter = require('events');
const fs = require('fs');

class TemperatureEmitter extends EventEmitter {
  constructor() {
    super();
    this.temperatureData = [];
  }

  logTemperature(date, temperature) {
    const data = { date, temperature };
    this.temperatureData.push(data);
    fs.writeFileSync('temperature.json', JSON.stringify(this.temperatureData));
    this.emit('temperatureLog', data);
  }

  calculateAverageTemperature(date) {
    const filteredData = this.temperatureData.filter((data) => data.date === date);
    const total = filteredData.reduce((acc, data) => acc + data.temperature, 0);
    const average = total / filteredData.length;
    console.log(`The average temperature on ${date} was ${average} degrees Celsius.`);
    this.emit('temperatureAverage', average);
  }

  checkTemperature(date, temperature) {
    if (temperature > 30) {
      console.log(`The temperature on ${date} was ${temperature} degrees Celsius, which is higher than 30 degrees Celsius.`);
      this.emit('temperatureHigh', temperature);
    }
  }
}

const temperatureEmitter = new TemperatureEmitter();

temperatureEmitter.on('temperatureLog', (data) => {
  console.log(`Temperature log: ${JSON.stringify(data)}`);
});

temperatureEmitter.on('temperatureAverage', (average) => {
  console.log(`Temperature average: ${average}`);
});

temperatureEmitter.on('temperatureHigh', (temperature) => {
  console.log(`Temperature too high: ${temperature}`);
});