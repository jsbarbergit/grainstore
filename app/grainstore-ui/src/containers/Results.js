import React, { useState, useEffect } from "react";
import "./Results.css";
import { useAppContext } from "../libs/contextLib";
import { useParams } from "react-router-dom";
import { API, Auth } from "aws-amplify";
import { LinkContainer } from "react-router-bootstrap";
import { Jumbotron, ListGroup, ListGroupItem } from "react-bootstrap";
import { onError } from "../libs/errorLib";

export default function Results() {
    const { customerId } = useParams();
    const [records, setRecords] = useState([]);
    const { isAuthenticated } = useAppContext();
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        async function loadRecord() {
            const user = await Auth.currentAuthenticatedUser();
            const token = user.signInUserSession.accessToken.jwtToken;
            const payload = {
                body: {
                    "CustomerId": customerId
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

    function renderRecordsList(records) {
        console.log('rendering');
        return [{}].concat(records.Items).map((record, i) =>
        i !== 0 ? (
          <LinkContainer key={record.UUID} to={{
              pathname: `/results/${customerId}/${record.UUID}`,
              state: {
                  recordData: record
              }
            }}>
            <ListGroup>
                <ListGroupItem action="true">
                    {i + ":  " + record.UUID}
                </ListGroupItem>
            </ListGroup>
          </LinkContainer>
        ):(
            <LinkContainer key={customerId} to={`/results/${customerId}`}>
                <ListGroupItem>
                <h4>
                    <b>{customerId.toUpperCase()}</b> Records (Click Row For Details): 
                </h4>
                </ListGroupItem>
            </LinkContainer>
        )
        );
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
            const count = records.Count
            summary = count + " Records Found"
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
