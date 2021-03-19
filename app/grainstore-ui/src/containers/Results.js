import React, { useState, useEffect } from "react";
import "./Results.css";
import { useAppContext } from "../libs/contextLib";
import { useParams } from "react-router-dom";
import { API, Auth } from "aws-amplify";
import { LinkContainer } from "react-router-bootstrap";
import { Jumbotron, ListGroup, ListGroupItem, Button } from "react-bootstrap";
import { onError } from "../libs/errorLib";
import { useHistory } from "react-router-dom";


export default function Results() {
    const { customerId } = useParams();
    const [records, setRecords] = useState([]);
    const { isAuthenticated } = useAppContext();
    const [isLoading, setIsLoading] = useState(true);
    const history = useHistory();
    useEffect(() => {
        async function loadRecord() {
            const user = await Auth.currentAuthenticatedUser();
            const token = user.signInUserSession.accessToken.jwtToken;
            // TODO If we have Nextrecord values - add them to the request body
            const payload = {
                body: {
                    "Account": customerId
                },
                headers: {
                    "Authorization": token,
                    "Content-Type": "application/json"
                }
            }
            // console.log(token)
            return API.post("grainstore-api", "/getrecord", payload);
        }

        async function onLoad() {
            try {
            const fetchedData = await loadRecord();
            setRecords(fetchedData);
            setIsLoading(false);
            } catch (e) {
            onError(e);
            }
        }

        onLoad();
        }, [customerId]);

    
    async function loadMoreItems() {
        console.log('loading more records');

        try {
        const nextBatch = await fetchNextBatch();
        setRecords(nextBatch);
        setIsLoading(false);
        renderRecordsList(records);
        } catch (e) {
        onError(e);
        }
    }

    async function fetchNextBatch() {
        console.log('loading more records');
        const user = await Auth.currentAuthenticatedUser();
        const token = user.signInUserSession.accessToken.jwtToken;
        // TODO If we have Nextrecord values - add them to the request body
        const payload = {
            body: {
                "Account": customerId,
                "LastEvaluatedKey":{
                    "Account": records.NextRecord.Account,
                    "Timestamp": records.NextRecord.Timestamp
                }
            },
            headers: {
                "Authorization": token,
                "Content-Type": "application/json"
            }
        }
        // console.log(token)
        return API.post("grainstore-api", "/getrecord", payload);
    }

    function renderRecordsList(records) {
        console.log('rendering');
        var return_data = ""
        if (records.Count > 0) { 
            console.log("records found");
            return_data = [{}].concat(records.Items).map((record, i) =>
                i !== 0 ? (
                    <LinkContainer key={record.UUID} to={{
                    pathname: `/results/${customerId}/${record.UUID}`,
                    state: {
                        recordData: record
                    }
                    }}>
                    <ListGroup>
                        <ListGroupItem action="true">
                        <h3>TicketID: {record.TicketID}</h3>
                        <b>Date:</b> {record.Timestamp.split('T', 1, 0)} <b>Time:</b> {record.Timestamp.substring(11,19)}
                        <br />  
                        <b>Vehicle Reg</b> {record.VehicleReg}
                        </ListGroupItem>  
                    </ListGroup>
                </LinkContainer>
                ):(
                    <LinkContainer key={customerId} to={`/results/${customerId}`}>
                        <ListGroupItem>
                        <h4>
                            <b>Click Ticket Below For Details:</b>
                        </h4>
                        </ListGroupItem>
                    </LinkContainer>
                )
                );
        }
        if (typeof records.NextRecord !== 'undefined') {
            const nextRecordAccount = records.NextRecord.Account;
            const nextRecordTimestamp = records.NextRecord.Timestamp;
            console.log('there is more. next record --> Account: ' + nextRecordAccount + ' Timestamp: ' + nextRecordTimestamp);
            return_data.push(<Button variant="primary" key="paginator" size="lg" block onClick={loadMoreItems}>Show more Records</Button>); 
            return_data.push(<Button variant="primary" key="goback" size="lg" block onClick={history.goBack}>Go Back</Button>);
        }
        
        return return_data;
    }

    function renderLander() {
    return (
        <div className="lander">
        <h1>Grainstore UI</h1>
        <p>You must login first</p>
        </div>
    );
    }

    function renderRecords() {
        var summary = "Searching for records..."
        if (typeof records.Count === 'undefined') {
            console.log('No records yet')
        } else if (records.Count === 0) {
            summary = 'No Records Found'
        }
        else {
            if (customerId.match(/^\d*$/)) {
                summary = "Ticket ID: " + customerId
            } else {
                summary = "Account: " + customerId.toUpperCase()
            }
        }
        
        
        return (
            <div className="records">
            <Jumbotron><h2>{summary}</h2></Jumbotron>
            <ListGroup>
                {!isLoading && renderRecordsList(records)}
            </ListGroup>
            </div>
        );
    }
    return (
    <div className="Home">
        {isAuthenticated ? renderRecords() : renderLander()}
    </div>
    );
}
