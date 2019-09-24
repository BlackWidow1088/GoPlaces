"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _moment = _interopRequireDefault(require("moment"));

var _uuid = _interopRequireDefault(require("uuid"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

class Reflection {
  /**
   * class constructor
   * @param {object} data
   */
  constructor() {
    this.reflections = [];
  }
  /**
   * 
   * @returns {object} reflection object
   */


  create(data) {
    const newReflection = {
      id: _uuid.default.v4(),
      success: data.success || '',
      lowPoint: data.lowPoint || '',
      takeAway: data.takeAway || '',
      createdDate: _moment.default.now(),
      modifiedDate: _moment.default.now()
    };
    this.reflections.push(newReflection);
    return newReflection;
  }
  /**
   * 
   * @param {uuid} id
   * @returns {object} reflection object
   */


  findOne(id) {
    return this.reflections.find(reflect => reflect.id === id);
  }
  /**
   * @returns {object} returns all reflections
   */


  findAll() {
    return this.reflections;
  }
  /**
   * 
   * @param {uuid} id
   * @param {object} data 
   */


  update(id, data) {
    const reflection = this.findOne(id);
    const index = this.reflections.indexOf(reflection);
    this.reflections[index].success = data['success'] || reflection.success;
    this.reflections[index].lowPoint = data['lowPoint'] || reflection.lowPoint;
    this.reflections[index].takeAway = data['takeAway'] || reflection.takeAway;
    this.reflections[index].modifiedDate = _moment.default.now();
    return this.reflections[index];
  }
  /**
   * 
   * @param {uuid} id 
   */


  delete(id) {
    const reflection = this.findOne(id);
    const index = this.reflections.indexOf(reflection);
    this.reflections.splice(index, 1);
    return {};
  }

}

var _default = new Reflection();

exports.default = _default;