function checkForm() {
	if (!document.newMember.id.value) {
		alert("아이디를 입력하세요.");
		return false;
	}
	
	if (!document.newMember.password.value) {
		alert("비밀번호를 입력하세요.");
		return false;
	}
	
	if (document.newMember.password.value != document.newMember.password_confirm.value) {
		alert("비밀번호를 동일하게 입력하세요.");
		return false;
	}
		
	function check(regExp, e, msg) {
        if (regExp.test(e.value)) {
            return true;
        }
        alert(msg);
        e.focus();
        return false;
    }

    // 모든 조건을 통과하면 폼을 제출합니다.
	document.getElementById("newMember").submit();
}