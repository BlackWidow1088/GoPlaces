"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _Reflection = _interopRequireDefault(require("../models/Reflection"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const Reflection = {
  /**
   * 
   * @param {object} req 
   * @param {object} res
   * @returns {object} reflection object 
   */
  create(req, res) {
    if (!req.body.success && !req.body.lowPoint && !req.body.takeAway) {
      return res.status(400).send({
        'message': 'All fields are required'
      });
    }

    const reflection = _Reflection.default.create(req.body);

    return res.status(201).send(reflection);
  },

  /**
   * 
   * @param {object} req 
   * @param {object} res 
   * @returns {object} reflections array
   */
  getAll(req, res) {
    const reflections = _Reflection.default.findAll();

    return res.status(200).send(reflections);
  },

  /**
   * 
   * @param {object} req 
   * @param {object} res
   * @returns {object} reflection object
   */
  getOne(req, res) {
    const reflection = _Reflection.default.findOne(req.params.id);

    if (!reflection) {
      return res.status(404).send({
        'message': 'reflection not found'
      });
    }

    return res.status(200).send(reflection);
  },

  /**
   * 
   * @param {object} req 
   * @param {object} res 
   * @returns {object} updated reflection
   */
  update(req, res) {
    const reflection = _Reflection.default.findOne(req.params.id);

    if (!reflection) {
      return res.status(404).send({
        'message': 'reflection not found'
      });
    }

    const updatedReflection = _Reflection.default.update(req.params.id, req.body);

    return res.status(200).send(updatedReflection);
  },

  /**
   * 
   * @param {object} req 
   * @param {object} res 
   * @returns {void} return statuc code 204 
   */
  delete(req, res) {
    const reflection = _Reflection.default.findOne(req.params.id);

    if (!reflection) {
      return res.status(404).send({
        'message': 'reflection not found'
      });
    }

    const ref = _Reflection.default.delete(req.params.id);

    return res.status(204).send(ref);
  }

};
var _default = Reflection;
exports.default = _default;