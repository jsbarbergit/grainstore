import React, { useState, useEffect } from "react";
import "./Results.css";
import { useLocation } from "react-router-dom";
import { Table, Image } from "react-bootstrap";
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
        return (
            // TODO Add a back to search resiults page link here
            <Table striped bordered hover variant="dark">
                <thead>
                    <tr>
                    <th>Key</th>
                    <th>Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Weight</td>
                        <td>£{record['Weight']}</td>
                    </tr>
                    <tr>
                        <td>Value</td>
                        <td>{record['Value']}kg</td>
                    </tr>
                    <tr>
                        <td>Photo</td>
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
             {isAuthenticated ? !isLoading && renderData() : renderLander()}
        </div>
    );
}