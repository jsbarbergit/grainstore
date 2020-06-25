(this["webpackJsonpgrainstore-ui"]=this["webpackJsonpgrainstore-ui"]||[]).push([[0],{101:function(e,t,a){},140:function(e,t,a){e.exports=a(228)},145:function(e,t,a){},152:function(e,t,a){},153:function(e,t,a){},154:function(e,t,a){},155:function(e,t,a){},228:function(e,t,a){"use strict";a.r(t);var n=a(1),r=a.n(n),c=a(37),l=a.n(c),o=a(20),u=(a(145),a(10)),s=a.n(u),i=a(18),m=a(15),p=a(8),d=a(43),E=a(244),f=a(245),h=a(131);a(152),a(153);function g(){return r.a.createElement("div",{className:"Home"},r.a.createElement("div",{className:"lander"},r.a.createElement("h1",null,"Grainstore UI"),r.a.createElement("p",null,"A simple UI for querying Grainstore Data")))}a(154);function b(){return r.a.createElement("div",{className:"NotFound"},r.a.createElement("h3",null,"Sorry, page not found!"))}var v=a(237),O=a(246),I=a(247),y=a(238),j=(a(155),a(51)),w=Object(n.createContext)(null);function k(){return Object(n.useContext)(w)}function x(){var e=k().userHasAuthenticated,t=Object(n.useState)(""),a=Object(m.a)(t,2),c=a[0],l=a[1],o=Object(n.useState)(""),u=Object(m.a)(o,2),d=u[0],E=u[1],f=Object(p.k)();function h(){return(h=Object(i.a)(s.a.mark((function t(a){return s.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return a.preventDefault(),t.prev=1,t.next=4,j.a.signIn(c,d);case 4:e(!0),f.push("/"),t.next=11;break;case 8:t.prev=8,t.t0=t.catch(1),alert(t.t0.message);case 11:case"end":return t.stop()}}),t,null,[[1,8]])})))).apply(this,arguments)}return r.a.createElement("div",{className:"Login"},r.a.createElement("form",{onSubmit:function(e){return h.apply(this,arguments)}},r.a.createElement(v.a,{controlId:"username"},r.a.createElement(O.a,null,"Username"),r.a.createElement(I.a,{autoFocus:!0,type:"username",value:c,onChange:function(e){return l(e.target.value)}})),r.a.createElement(v.a,{controlId:"password"},r.a.createElement(O.a,null,"Password"),r.a.createElement(I.a,{value:d,onChange:function(e){return E(e.target.value)},type:"password"})),r.a.createElement(y.a,{block:!0,disabled:!(c.length>0&&d.length>0),type:"submit"},"Login")))}a(101);var U=a(243),N=a(239),C=a(129),S=a(240);function D(e){var t=e.toString();e instanceof Error||!e.message||(t=e.message),alert(t)}function L(){var e=Object(p.m)().customerId,t=Object(n.useState)([]),a=Object(m.a)(t,2),c=a[0],l=a[1],o=k().isAuthenticated,u=Object(n.useState)(!0),E=Object(m.a)(u,2),f=E[0],h=E[1];return Object(n.useEffect)((function(){function t(){return a.apply(this,arguments)}function a(){return(a=Object(i.a)(s.a.mark((function t(){var a,n,r;return s.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,j.a.currentAuthenticatedUser();case 2:return a=t.sent,n=a.signInUserSession.accessToken.jwtToken,r={body:{CustomerId:e},headers:{Authorization:n,"Content-Type":"application/json"}},t.abrupt("return",U.a.post("grainstore-api","/getrecord",r));case 6:case"end":return t.stop()}}),t)})))).apply(this,arguments)}function n(){return(n=Object(i.a)(s.a.mark((function e(){var a;return s.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,t();case 3:a=e.sent,l(a),h(!1),e.next=11;break;case 8:e.prev=8,e.t0=e.catch(0),D(e.t0);case 11:case"end":return e.stop()}}),e,null,[[0,8]])})))).apply(this,arguments)}!function(){n.apply(this,arguments)}()}),[e]),r.a.createElement("div",{className:"Home"},o?function(){var t="Searching for records...";if("undefined"===typeof c.Count)console.log("No records yet");else if(0===c.Count)t="No Records Found";else{t=c.Count+" Records Found"}return r.a.createElement("div",{className:"records"},r.a.createElement(S.a,null,r.a.createElement("h2",null,t)),r.a.createElement(N.a,null,!f&&function(t){return console.log("rendering"),[{}].concat(t.Items).map((function(t,a){return 0!==a?r.a.createElement(d.LinkContainer,{key:t.UUID,to:{pathname:"/results/".concat(e,"/").concat(t.UUID),state:{recordData:t}}},r.a.createElement(N.a,null,r.a.createElement(C.a,{action:"true"},a+":  "+t.UUID))):r.a.createElement(d.LinkContainer,{key:e,to:"/results/".concat(e)},r.a.createElement(C.a,null,r.a.createElement("h4",null,r.a.createElement("b",null,e.toUpperCase())," Records (Click Row For Details):")))}))}(c)))}():r.a.createElement("div",{className:"lander"},r.a.createElement("h1",null,"Grainstore UI"),r.a.createElement("p",null,"You must login first")))}var A=a(241),P=a(242);function R(){var e=Object(p.l)().state.recordData,t=Object(n.useState)([]),a=Object(m.a)(t,2),c=a[0],l=a[1],o=Object(n.useState)(!0),u=Object(m.a)(o,2),d=u[0],E=u[1],f=k().isAuthenticated;return Object(n.useEffect)((function(){function t(){return a.apply(this,arguments)}function a(){return(a=Object(i.a)(s.a.mark((function t(){var a,n,r;return s.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,j.a.currentAuthenticatedUser();case 2:return a=t.sent,n=a.signInUserSession.accessToken.jwtToken,r={body:{UUID:e.UUID,ImageKey:e.ImageKey},headers:{Authorization:n,"Content-Type":"application/json"}},console.log("Fetching signed URL for Image"),t.abrupt("return",U.a.post("grainstore-api","/publishimage",r));case 7:case"end":return t.stop()}}),t)})))).apply(this,arguments)}function n(){return(n=Object(i.a)(s.a.mark((function e(){var a;return s.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,t();case 3:a=e.sent,l(a),E(!1),e.next=11;break;case 8:e.prev=8,e.t0=e.catch(0),D(e.t0);case 11:case"end":return e.stop()}}),e,null,[[0,8]])})))).apply(this,arguments)}!function(){n.apply(this,arguments)}()}),[e]),r.a.createElement("div",{className:"Data"},f?!d&&r.a.createElement(A.a,{striped:!0,bordered:!0,hover:!0,variant:"dark"},r.a.createElement("thead",null,r.a.createElement("tr",null,r.a.createElement("th",null,"Key"),r.a.createElement("th",null,"Value"))),r.a.createElement("tbody",null,r.a.createElement("tr",null,r.a.createElement("td",null,"Weight"),r.a.createElement("td",null,"\xa3",e.Weight)),r.a.createElement("tr",null,r.a.createElement("td",null,"Value"),r.a.createElement("td",null,e.Value,"kg")),r.a.createElement("tr",null,r.a.createElement("td",null,"Photo"),r.a.createElement("td",null,r.a.createElement(P.a,{src:c,rounded:!0,fluid:!0}))))):r.a.createElement("div",{className:"lander"},r.a.createElement("h1",null,"Grainstore UI"),r.a.createElement("p",null,"You must login first")))}function G(){return r.a.createElement(p.g,null,r.a.createElement(p.d,{exact:!0,path:"/"},r.a.createElement(g,null)),r.a.createElement(p.d,{exact:!0,path:"/login"},r.a.createElement(x,null)),r.a.createElement(p.d,{exact:!0,path:"/results/:customerId"},r.a.createElement(L,null)),r.a.createElement(p.d,{exact:!0,path:"/results/:customerId/:record"},r.a.createElement(R,null)),r.a.createElement(p.d,null,r.a.createElement(b,null)))}a(227);var T=function(){var e=Object(n.useState)(!1),t=Object(m.a)(e,2),a=t[0],c=t[1],l=Object(n.useState)(!0),u=Object(m.a)(l,2),g=u[0],b=u[1];Object(n.useEffect)((function(){!function(){x.apply(this,arguments)}()}),[]);var v=Object(p.k)(),O=Object(n.useState)(""),I=Object(m.a)(O,2),y=I[0],k=I[1];function x(){return(x=Object(i.a)(s.a.mark((function e(){return s.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,j.a.currentSession();case 3:c(!0),e.next=9;break;case 6:e.prev=6,e.t0=e.catch(0),"No current user"!==e.t0&&alert(e.t0);case 9:b(!1);case 10:case"end":return e.stop()}}),e,null,[[0,6]])})))).apply(this,arguments)}function U(){return(U=Object(i.a)(s.a.mark((function e(){return s.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.next=2,j.a.signOut();case 2:c(!1),v.push("/login");case 4:case"end":return e.stop()}}),e)})))).apply(this,arguments)}return!g&&r.a.createElement("div",{className:"App container"},r.a.createElement(E.a,{collapseOnSelect:!0},r.a.createElement(E.a.Brand,null,r.a.createElement("h1",null,r.a.createElement(o.Link,{to:"/"},"Grainstore UI"))),r.a.createElement(E.a.Toggle,null),r.a.createElement(E.a.Collapse,null,r.a.createElement(f.a,null,a?r.a.createElement(h.a,{onClick:function(){return U.apply(this,arguments)}},"Logout"):r.a.createElement(r.a.Fragment,null,r.a.createElement(d.LinkContainer,{to:"/login"},r.a.createElement(h.a,null,"Login"))))),r.a.createElement(f.a,null,a?r.a.createElement(h.a,null,r.a.createElement("form",{className:"form-inline",onSubmit:function(){v.push("/results/"+y)}},r.a.createElement("input",{className:"form-control mr-sm-2",type:"search",placeholder:"Enter CustomerId","aria-label":"Enter CustomerId",value:y,onChange:function(e){var t=e.target;k(t.value)}}),r.a.createElement("button",{className:"btn btn-outline-success my-2 my-sm-0",type:"submit"},"Search"))):r.a.createElement(r.a.Fragment,null))),r.a.createElement(w.Provider,{value:{isAuthenticated:a,userHasAuthenticated:c}},r.a.createElement(G,null)))};Boolean("localhost"===window.location.hostname||"[::1]"===window.location.hostname||window.location.hostname.match(/^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/));var _={cognito:{REGION:"eu-west-2",USER_POOL_ID:"eu-west-2_9E8x3OLUG",APP_CLIENT_ID:"34q2kn7hddiru0njfkevden2hr"},apiGateway:{REGION:"eu-west-2",URL:"https://aojuwiinsb.execute-api.eu-west-2.amazonaws.com/dev"}};a(30).a.configure({Auth:{mandatorySignIn:!0,region:_.cognito.REGION,userPoolId:_.cognito.USER_POOL_ID,identityPoolId:_.cognito.IDENTITY_POOL_ID,userPoolWebClientId:_.cognito.APP_CLIENT_ID},API:{endpoints:[{name:"grainstore-api",endpoint:_.apiGateway.URL,region:_.apiGateway.REGION}]}}),l.a.render(r.a.createElement(o.BrowserRouter,null,r.a.createElement(T,null)),document.getElementById("root")),"serviceWorker"in navigator&&navigator.serviceWorker.ready.then((function(e){e.unregister()})).catch((function(e){console.error(e.message)}))}},[[140,1,2]]]);
//# sourceMappingURL=main.4a46da11.chunk.js.map