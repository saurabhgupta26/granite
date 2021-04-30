import React, { useEffect, useState } from "react";
import { initializeLogger } from "common/logger";
import Dashboard from "components/Dashboard";
import CreateTask from "components/Tasks/CreateTask";
import ShowTask from "components/Tasks/ShowTask";
import { registerIntercepts, setAuthHeaders } from "apis/axios";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import { ToastContainer } from "react-toastify";

const App = () => {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    registerIntercepts();
    initializeLogger();
    setAuthHeaders(setLoading);
  }, []);

  return (
    <Router>
      <ToastContainer />
      <Switch>
        <Route exact path="/tasks/:slug/show" component={ShowTask} />
        <Route exact path="/tasks/create" component={CreateTask} />
        <Route exact path="/dashboard" component={Dashboard} />
      </Switch>
    </Router>
  );
};

export default App;

// import React, { useEffect } from "react";
// import { Route, Switch, BrowserRouter as Router } from "react-router-dom";

// const App = () => {
//   useEffect(() => {
//     initializeLogger();
//     logger.info("Log from js-logger");
//   }, []);

//   return (
//     <Router>
//       <Switch>
//         <Route exact path="/" render={() => <div>Home</div>} />
//         <Route exact path="/about" render={() => <div>About</div>} />
//       </Switch>
//     </Router>
//   );
// };

// export default App;
