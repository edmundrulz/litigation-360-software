const services = {
  identity: null,
  rbac: null,
  audit: null,
  notification: null,
  automation: null,
  workflow: null,
  document: null,
  search: null,
  knowledge: null,
  reporting: null,
  analytics: null,
  integration: null,
  billing: null,
  calendar: null,
  task: null,
  ai: null
};

function register(name, instance) {
  services[name] = instance;
}

function get(name) {
  return services[name];
}

function exists(name) {
  return services[name] !== null;
}

function list() {
  return Object.keys(services);
}

module.exports = {
  register,
  get,
  exists,
  list
};
