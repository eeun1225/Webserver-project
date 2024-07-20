function CheckAddChallenge() {
    var title = document.getElementById("title");
    var description = document.getElementById("description");
    var coin = document.getElementById("coin");
    var capacity = document.getElementById("capacity");
    var due_date = document.getElementById("due_date");
    var frequency = document.getElementById("frequency");

    if (title.value.length < 4 || title.value.length > 50) {
        alert("제목\n최소 4자에서 최대 50자까지 입력하세요");
        title.focus();
        return false;
    }

    if (capacity.value < 3) {
        alert("[인원]\n3명 이상부터 가능합니다.");
        capacity.focus();
        return false;
    }

    if (coin.value < 100) {
        alert("[코인]\n100원부터 입력할 수 있습니다.");
        coin.focus();
        return false;
    }

    if (description.value.length < 100) {
        alert("[상세설명]\n최소 100자 이상 입력하세요");
        description.focus();
        return false;
    }
    
    if (!due_date.value) {
        alert("[마감일]\n날짜를 선택하세요.");
        description.focus();
        return false;
    }
    
    if (frequency < 1 || frequency > 7) {
        alert("[빈도]\n주 1일에서 주 7일까지만 가능합니다.");
        description.focus();
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
    document.getElementById("newChallenge").submit();
}
