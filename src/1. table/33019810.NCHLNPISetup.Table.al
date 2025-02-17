table 33019810 "NCHL-NPI Setup"
{
    Caption = 'NCHL-NPI Setup';
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Base URL"; Text[50])
        {
        }
        field(3; "Username (Basic Auth.)"; Text[50])
        {
        }
        field(4; "Password (Basic Auth.)"; Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(5; "Username (User Auth.)"; Text[50])
        {
        }
        field(6; "Password (User Auth.)"; Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(7; "Refresh Token Validity"; Duration)
        {
        }
        field(8; "Access Token Validity"; Duration)
        {
        }
        field(9; "Refresh Token Generated On"; DateTime)
        {
        }
        field(10; "Access Token Generated On"; DateTime)
        {
        }
        field(11; "Refresh Token"; Text[250])
        {
        }
        field(12; "Access Token"; Text[250])
        {
        }
        field(13; "Success Status Code"; Code[10])
        {
        }
        field(14; "Rest Method"; Option)
        {
            OptionCaption = 'GET,POST,PUT,DELETE';
            OptionMembers = GET,POST,PUT,DELETE;
        }
        field(15; "Non-Real Time Batch ID Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "Certificate Path"; Text[50])
        {
        }
        field(22; "Certificate Password"; Text[30])
        {
            ExtendedDatatype = Masked;
        }
        field(23; "Hash Algorithm"; Text[20])
        {
        }
        field(24; "Real Time Batch ID Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Alt. Code (Bank Validation)"; Code[10])
        {
        }
        field(26; "Alt. Match % (Bank Validation)"; Integer)
        {
        }
        field(27; "Max API Call Count"; Integer)
        {
        }
        field(28; "Notify Receiver via Email"; Boolean)
        {
        }
        field(50000; "Per Transaction Limit"; Decimal)
        {
        }
        field(50001; "Per Day Total Trans. Limit"; Decimal)
        {
        }
        field(50002; "User Change Approver Email"; Text[250])
        {
        }
        field(50003; "Notification Gateway Method"; Option)
        {
            Description = 'setup on how to notify the concerned person';
            OptionMembers = " ",SMS,"E-Mail",Both;
        }
        field(50004; "Use OTP Authentication"; Boolean)
        {
        }
        field(50005; "OTP Character Length"; Integer)
        {
        }
        field(50006; "OTP Expiry Period"; Duration)
        {
        }
        field(50009; "APP ID IRD"; Text[50])
        {
            Description = '//IRD';

            trigger OnLookup()
            var
                NCHLServiceMgt: Codeunit "33019811";
                NCHLOffice: Page "33019814";
                TempNCHLOffice: Record "33019814";
                CompanyInfo: Record "79";
            begin

                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                    ERROR('NCHL is not enabled.');

                NCHLServiceMgt.getListOfApps('GON');
                CLEAR(NCHLOffice);
                TempNCHLOffice.RESET;
                TempNCHLOffice.SETCURRENTKEY(Agent);
                TempNCHLOffice.SETRANGE("End to End ID", 'TEMPAPPS');
                NCHLOffice.SETRECORD(TempNCHLOffice);
                NCHLOffice.SETTABLEVIEW(TempNCHLOffice);
                NCHLOffice.LOOKUPMODE(TRUE);
                COMMIT;
                IF NCHLOffice.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    NCHLOffice.GETRECORD(TempNCHLOffice);
                    "APP ID IRD" := TempNCHLOffice.Agent;
                    //"App Group" := TempNCHLOffice.Name;
                END;

                TempNCHLOffice.RESET;
                TempNCHLOffice.SETRANGE("End to End ID", 'TEMPAPPS');
                TempNCHLOffice.DELETEALL;
            end;
        }
        field(50010; "APP ID CIT"; Text[50])
        {
            Description = '//CIT';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

