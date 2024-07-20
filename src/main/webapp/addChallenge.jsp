<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<script type="text/javascript" src="./resources/js/validation.js"></script>
<title>개설</title>
<script type="text/javascript">
    function getCurrentDate() {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }

        today = yyyy + '-' + mm + '-' + dd;
        return today;
    }

    // 페이지 로드 시 시작일과 종료일의 최소값을 설정하는 함수
    window.onload = function() {
        document.getElementById("due_date").setAttribute("min", getCurrentDate());
    }
</script>
</head>
<body>
<%@include file="navbar.jsp" %>
<fmt:bundle basename="bundle.message">
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<div class="container py-4">
	<div class="p-5 mb-5 bg-body-tertiary rounded-3">
		<div class="container-fluid py-1">
			<h1 class="display-5 fw-bold"></h1>
			<p class="col-md-8 fs-4"><fmt:message key="addchallenge" /></p>
		</div>
	</div>
	<div class="row-align-items-md-stretch">
		<div class = "text-end">
			<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
		</div>
		<form name="newChallenge" action="./processAddChallenge.jsp" method="post">
            <div class="mb-3 row">
                <div class="col-sm-10"> 
                    <textarea name="title" id="title" cols="100" rows="1" class="form-control" placeholder="제목을 입력해주세요."></textarea>
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-1"><fmt:message key="coin" /></label>
                <div class="col-sm-2">
                    <input type="number" id="coin" name="coin" class="form-control">
                </div>
            
                <label class="col-sm-1"><fmt:message key="Capacity" /></label>
                <div class="col-sm-2">
                    <input type="number" name="capacity" class="form-control">
                </div>
                <div class="col-sm-3">
					<select name="category" id="category" class="form-select">
                        <option value="규칙적인 생활"><fmt:message key="RegularRoutine" /></option>
                        <option value="공부"><fmt:message key="Study" /></option>
                        <option value="운동"><fmt:message key="Exercise" /></option>
                        <option value="식습관"><fmt:message key="EatingHabits" /></option>
                        <option value="취미"><fmt:message key="Hobbies" /></option>
                        <option value="셀프케어"><fmt:message key="Self-Care" /></option>
                        <option value="에코*펫"><fmt:message key="Eco&Pet" /></option>
                        <option value="마음챙김"><fmt:message key="Mindfulness" /></option>
                	</select> 
				</div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-1"><fmt:message key="deadline" /></label>
                <div class="col-sm-2">
                    <input type="date" id="due_date" name="due_date" class="form-control">
                </div>
                <label class="col-sm-1"><fmt:message key="duration" /></label>
                <div class="col-sm-2">
                    <select name="period" id="period" class="form-select">
                        <option value="3일"><fmt:message key="3day" /></option>
                        <option value="1주일"><fmt:message key="1week" /></option>
                        <option value="2주일"><fmt:message key="2week" /></option>
                        <option value="1개월"><fmt:message key="1month" /></option>
                        <option value="3개월"><fmt:message key="3month" /></option>
                        <option value="6개월"><fmt:message key="6month" /></option>
                        <option value="1년"><fmt:message key="1year" /></option>
                	</select> 
                </div>
                <label class="col-sm-1"><fmt:message key="frequency" /></label>
                <div class="col-sm-1">
					<div class="input-group">
        				<input type="number" id="frequency" name="frequency" class="form-control"><fmt:message key="days" />
					</div>
				</div>
                <div class="col-sm-2">
					<select name="certification" id="certification" class="form-select">
                        <option value="이미지"><fmt:message key="image" /></option>
                        <option value="비디오"><fmt:message key="video" /></option>
                        <option value="텍스트"><fmt:message key="text" /></option>
                        <option value="문서"><fmt:message key="document" /></option>
                	</select> 
				</div>
            </div>
            <div class="mb-3 row">
                <div class="col-sm-10">
                    <textarea name="description" id="description" cols="100" rows="10" class="form-control" placeholder="설명을 입력해주세요."></textarea>
                </div>
            </div>
            <div class="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" class="btn btn-primary" value="<fmt:message key="register" />">
                </div>
            </div>
		</form>
	</div>
</div>
</fmt:bundle>
</body>
</html>