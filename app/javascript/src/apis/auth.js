import axios from "axios";

const login = payload => axios.post("/sessions", payload);

const signup = payload => axios.post("/users", payload);

const logout = () => axios.delete(`/sessions`);

const authApi = {
  login,
  logout,
  signup,
};

export default authApi;
