<%@ include file="/common/checkSession.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%
request.setAttribute("user_ip", request.getLocalAddr());
%>
<sql:setDataSource var="db" driver="oracle.jdbc.driver.OracleDriver" url="jdbc:oracle:thin:@localhost:1521:orcl" user="scott" password="tiger"/>

<sql:transaction dataSource="${db}">
	<sql:update var="count">
		DELETE FROM USERS WHERE USER_ID = ?
		<sql:param value="${sessionScope.user_id}"/>
	</sql:update>	
	<sql:update>
		INSERT INTO USERS_HIST(
			USER_ID, OCCUR_CASE, OCCUR_DATE, OCCUR_IP
		) VALUES(
			?, ?, SYSDATE, ?
		)
		<sql:param value="${sessionScope.user_id}"/>
		<sql:param value="90"/>
		<sql:param value="${requestScope.user_ip}"/>
	</sql:update>
</sql:transaction>

<c:if test="${count > 0}">
	<%session.invalidate();%>
	<script>alert("탈퇴되었습니다.");</script>
</c:if>

<script>
	location.href="/main.jsp";
</script>