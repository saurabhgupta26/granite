import React from "react";
import Dashboard from "components/Dashboard";

import CreateTask from "components/Tasks/CreateTask";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
const App = () => {
  return (
    <Router>
      <Switch>
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
