table 33019800 "Catalogues Master"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,Credit Facility Type,Ownership Type,Purpose of Credit Facility,Repayment Frequency,Asset Classification,Credit Facility Status,Secutity Coverage Flag,Legal Action Taken,Reason for Closure,Maritial Status,Address Type,Business Activity Code,Legal Status,Group,Type of Security,Security Owernship Type,Security Valuator Type,Nature of Change,Employment Type,Related Entity Type,Nature of Relationship,Guarantee Type,Commercial Registration Organization,District,Nature of Data,Currency,Gender,Country,Issued Authority,Payment Delay History Flag';
            OptionMembers = " ","Credit Facility Type","Ownership Type","Purpose of Credit Facility","Repayment Frequency","Asset Classification","Credit Facility Status","Secutity Coverage Flag","Legal Action Taken","Reason for Closure","Maritial Status","Address Type","Business Activity Code","Legal Status",Group,"Type of Security","Security Owernship Type","Security Valuator Type","Nature of Change","Employment Type","Related Entity Type","Nature of Relationship","Guarantee Type","Commercial Registration Organization",District,"Nature of Data",Currency,Gender,Country,"Issued Authority","Payment Delay History Flag";
        }
        field(3; "Catalogue Value"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "Code", Type, "Catalogue Value")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

