//get custom format date
export function getDate(date: Date) :string {
    let day=addZero(date.getDate());
    let month=addZero(date.getMonth()+1);
    const year=date.getFullYear().toString().slice(-2);

    let hour=addZero(date.getHours());
    let minutes=addZero(date.getMinutes());

    return `${day}/${month}/${year} at ${hour}:${minutes}`;
}

//add zero before the number
export function addZero(num: any) :string{
    const str=num.toString();
    if(str.length==1){
        return `0${str}`;
    }
    return num;
}
