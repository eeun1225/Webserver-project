<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    function checkForm() {
        let regExpName = /^[가-힣]*$/;

        if (!document.newMember.id.value) {
            alert("아이디를 입력하세요.");
            return false;
        }

        if (document.newMember.id.value.length < 5 || document.newMember.id.value.length > 13) {
            alert("아이디는 5자 이상 13자 이하로 입력해 주세요.");
            return false;
        }

        if(!regExpName.test(document.newMember.name.value)){
            alert("이름은 한글만으로 입력해 주세요.");
            return false;
        }

        var birthyy = document.newMember.birthyy.value;
        var birthmm = document.newMember.birthmm.value;
        var birthdd = document.newMember.birthdd.value;

        if (birthyy < 1924 || birthyy > 2024) {
            alert("올바른 생년을 입력해 주세요.");
            return false;
        }

        switch(parseInt(birthmm)){
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12: {
            if (birthdd < 1 || birthdd > 31) {
                alert("올바른 생일을 입력해 주세요.");
                return false;
            }
            break;
        }
        case 4:
        case 6:
        case 9:
        case 11: {
            if (birthdd < 1 || birthdd > 30) {
                alert("올바른 생일을 입력해 주세요.");
                return false;
            }
            break;
        }
        case 2: {
            if (birthdd < 1 || birthdd > 29) {
                alert("올바른 생일을 입력해 주세요.");
                return false;
            }
            break;
        }
        }   

        if (!document.newMember.password.value) {
            alert("비밀번호를 입력하세요.");
            return false;
        }

        if (document.newMember.password.value.length < 8 || document.newMember.password.value.length > 15) {
            alert("비밀번호는 8자 이상 15자 이하로 입력해 주세요.");
            return false;
        }

        if (document.newMember.password.value != document.newMember.password_confirm.value) {
            alert("비밀번호를 동일하게 입력하세요.");
            return false;
        }

        if (!validatePhone()) {
            return false;
        }

        return true;
    }

    function checkDuplicateId(showMessage = true) {
        var id = document.newMember.id.value;
        if (!id) {
            alert("아이디를 입력하세요.");
            return false;
        }

        var result = false;

        $.ajax({
            url: 'check_id.jsp',
            type: 'POST',
            data: { id: id },
            async: false,
            success: function(response) {
                if (response.trim() === 'OK') {
                    if (showMessage) {
                        alert('사용 가능한 아이디입니다.');
                    }
                    result = true;
                } else {
                    alert('이미 사용 중인 아이디입니다.');
                    result = false;
                }
            },
            error: function() {
                alert('아이디 중복 검사에 실패했습니다.');
                result = false;
            }
        });

        return result;
    }

    function onRegisterClick() {
        // 가입 버튼을 눌렀을 때는 중복검사 메시지를 표시하지 않도록 설정
        return checkDuplicateId(false) && checkForm();
    }
</script>
<title>회원 가입</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<div class="container py-4">
	<div class="text-end">
    	<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    </div>

 <div class="p-5 mb-4 bg-body-tertiary rounded-3">
      <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold"><fmt:message key="signin" /></h1>
        <p class="col-md-8 fs-4">Membership Joining</p>      
      </div>
    </div>
    

   <div class="row align-items-md-stretch   text-center">
        <form name="newMember"  action="signin_process.jsp" method="post" onsubmit="return onRegisterClick()">
            <div class="mb-3 row">
                <label class="col-sm-2 "><fmt:message key="id" /></label>
                <div class="col-sm-3">
                    <input name="id" type="text" class="form-control" placeholder="id" >
                </div>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-secondary" onclick="checkDuplicateId(true)"><fmt:message key="DuplicateCheck" /></button>
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="pw" /></label>
                <div class="col-sm-3">
                    <input name="password" type="text" class="form-control" placeholder="password" >
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="pwcheck" /></label>
                <div class="col-sm-3">
                    <input name="password_confirm" type="text" class="form-control" placeholder="password confirm" >
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="name" /></label>
                <div class="col-sm-3">
                    <input name="name" type="text" class="form-control" placeholder="name" >
                </div>
            </div>
            
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="birth" /></label>
                <div class="col-sm-10  ">
                  <div class="row">
                    <div class="col-sm-2">
                        <input type="text" name="birthyy" maxlength="4"  class="form-control" placeholder="<fmt:message key="year" />(4자)" size="6"> 
                    </div>
                    <div class="col-sm-2">
                    <select name="birthmm" class="form-select">
                        <option value=""><fmt:message key="month" /></option>
                        <option value="01">1</option>
                        <option value="02">2</option>
                        <option value="03">3</option>
                        <option value="04">4</option>
                        <option value="05">5</option>
                        <option value="06">6</option>
                        <option value="07">7</option>
                        <option value="08">8</option>
                        <option value="09">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                    </select> 
                    </div>
                    <div class="col-sm-2">
                    <input type="text" name="birthdd" maxlength="2" class="form-control" placeholder="일" size="4">
                    </div>
                </div>
                </div>
            </div>
            
        <div class="mb-3 row">
            <label class="col-sm-2"><fmt:message key="mail" /></label>
                <div class="col-sm-10">
                  <div class="row">
                    <div class="col-sm-4">
                        <input type="text" name="mail1" maxlength="50" class="form-control"  placeholder="email">
                    </div> @
                    <div class="col-sm-3">
                         <select name="mail2" class="form-select">
                            <option>naver.com</option>
                            <option>daum.net</option>
                            <option>gmail.com</option>
                            <option>nate.com</option>
                        </select>
                    </div>
                </div>      
            </div>      
        </div>
            <div class="mb-3 row">
                <label class="col-sm-2"><fmt:message key="phone" /></label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <select name="phone_prefix" class="form-select">
                                <option value="010">010</option>
                                <option value="070">070</option>
                                <option value="011">011</option>
                            </select>
                            <input name="phone_mid" type="text" class="form-control" placeholder="####" maxlength="4" pattern="\d{4}" required>
                            <input name="phone_suffix" type="text" class="form-control" placeholder="####" maxlength="4" pattern="\d{4}" required>
                        </div>
                    </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 "><fmt:message key="address" /></label>
                <div class="col-sm-5">
                    <input name="address" type="text" class="form-control" placeholder="address" >
                </div>
            </div>
            <div class="mb-3 row">
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary"><fmt:message key="signin" /></button>
                    <input type="reset" class="btn btn-primary " value="취소" onclick="reset()" >
                </div>
            </div>
        </form>
    </div>
</div>
</fmt:bundle>
</body>
</html>