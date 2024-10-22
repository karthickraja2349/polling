<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Acknowledgment</title>
    <style>
        /* Container styles */
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #f9f9f9;
        }

        h1, p {
            text-align: center;
        }

        p {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Thank You for Voting!</h1>
        <p>Name: <%= request.getParameter("voter_name") %></p>
        <p>Voter ID: <%= request.getParameter("voter_id") %></p>
        <p>Electoral District: <%= request.getParameter("electoral_district") %></p>

        <%
            String voterName = request.getParameter("voter_name");
            String voterId = request.getParameter("voter_id");
            String electoralDistrict = request.getParameter("electoral_district");
            String candidateId = request.getParameter("candidate_id");
            String votingParty = "";

            switch (candidateId) {
                case "1":
                    votingParty = "DMK";
                    break;
                case "2":
                    votingParty = "AIADMK";
                    break;
                case "3":
                    votingParty = "BJP";
                    break;
                case "4":
                    votingParty = "SELF";
                    break;
                default:
                    votingParty = "Unknown";
            }

            // Database connection
            String url = "jdbc:mysql://localhost:3306/polling"; 
            String username = "main"; 
            String password = "zoho"; 

            Connection conn = null;
            PreparedStatement preparedStatement = null;

            try {
                // Load MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish connection
                conn = DriverManager.getConnection(url, username, password);

                // Prepare SQL INSERT statement
                String sql = "INSERT INTO voters (voter_name, voter_id, electoral_district, candidate_id, voting_party) VALUES (?, ?, ?, ?, ?)";
                preparedStatement = conn.prepareStatement(sql);
                preparedStatement.setString(1, voterName);
                preparedStatement.setInt(2, Integer.parseInt(voterId));
                preparedStatement.setString(3, electoralDistrict);
                preparedStatement.setInt(4, Integer.parseInt(candidateId));
                preparedStatement.setString(5, votingParty);

                // Execute INSERT statement
                int rowsAffected = preparedStatement.executeUpdate();
                if (rowsAffected > 0) {
                    out.println("<p>Your voting information has been recorded successfully!</p>");
                } 
                else {
                    out.println("<p>There was an error recording your voting information.</p>");
                }
            } 
            catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } 
            catch (ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (preparedStatement != null) preparedStatement.close();
                    if (conn != null) conn.close();
                } 
                catch (SQLException e) {
                    e.printStackTrace();
                }
            }  
        %>

        <p>Candidate Name: <%= request.getParameter("candidate_id") %></p>
        <p>Voting Party: <%= votingParty %></p>
    </div>
</body>
</html>

