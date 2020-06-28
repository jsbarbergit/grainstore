import React, { useState, useEffect } from "react";
import "./Results.css";
import { useLocation } from "react-router-dom";
import { Table, Image, Badge } from "react-bootstrap";
import { API, Auth } from "aws-amplify";
import { onError } from "../libs/errorLib";
import { useAppContext } from "../libs/contextLib";

export default function Data() {
    const location = useLocation();
    const record = location.state.recordData;
    const [url, setUrl] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const { isAuthenticated } = useAppContext();

    useEffect(() => {
        async function generatePreSignedUrl() {
            const user = await Auth.currentAuthenticatedUser();
            const token = user.signInUserSession.accessToken.jwtToken;
            const payload = {
                body: {
                    "UUID": record['UUID'],
                    "ImageKey": record['ImageKey']
                },
                headers: {
                    "Authorization": token,
                    "Content-Type": "application/json"
                }
            };
            console.log('Fetching signed URL for Image');
            return API.post("grainstore-api", "/publishimage", payload);
        }

        async function onLoad() {
            try {
            const signedUrl = await generatePreSignedUrl();
            setUrl(signedUrl);
            setIsLoading(false);
            } catch (e) {
            onError(e);
            }
        }
        onLoad();
        }, [record]);

    function renderLander() {
        return (
            <div className="lander">
            <h1>Grainstore UI</h1>
            <p>You must login first</p>
            </div>
        );
    }

    function renderData() {
        // Convert Timestamp string back into Date format
        const iso_timestamp = new Date(record['Timestamp']);
        console.log(iso_timestamp.toLocaleTimeString());
        return ( 
            // TODO Add a back to search results page link here
            <Table striped bordered hover variant="dark">
                <thead>
                    <tr>
                    <th>Key</th>
                    <th>Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Record Datetime</td>
                        <td>{iso_timestamp.toLocaleDateString()}  -  {iso_timestamp.toLocaleTimeString()}</td>
                    </tr>
                    <tr>
                        <td>Crop</td>
                        <td>{record['Crop']}</td>
                    </tr>
                    <tr>
                        <td>Direction</td>
                        <td>{record['Direction']}</td>
                    </tr>
                    <tr>
                        <td>Vehicel Reg</td>
                        <td>{record['VehicleReg']}</td>
                    </tr>
                    <tr>
                        <td>Admix</td>
                        <td>{record['AdmixPct']} %</td>
                    </tr>
                    <tr>
                        <td>Bushel Weight</td>
                        <td>{record['BushelKg']} Kg</td>
                    </tr>
                    <tr>
                        <td>Dry Weight </td>
                        <td>{record['DryWeightTonnes']} tonnes</td>
                    </tr>
                    <tr>
                        <td>Moisture</td>
                        <td>{record['MoisturePct']} %</td>
                    </tr>
                    <tr>
                        <td>Wet Weight</td>
                        <td>{record['WetWeightTonnes']} tonnes</td>
                    </tr>
                    <tr>
                        <td>Sample Bag</td>
                        <td>
                            <Image src={url} rounded fluid />
                        </td>
                    </tr>
                </tbody>
            </ Table>

        );
    };

    return (
        <div className="Data">

            <h1><Badge variant="primary">Account:</Badge><Badge variant="light">{record['Account']}</Badge></h1> 
            <h1><Badge variant="secondary">TicketID:</Badge><Badge variant="light">{record['TicketID']}</Badge></h1>
             {isAuthenticated ? !isLoading && renderData() : renderLander()}
        </div>
    );
}