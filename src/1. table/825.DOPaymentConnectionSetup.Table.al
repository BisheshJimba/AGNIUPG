table 825 "DO Payment Connection Setup"
{
    Caption = 'Microsoft Dynamics ERP Payment Services Setup';
    Permissions = TableData 824 = rd;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Active; Boolean)
        {
            Caption = 'Active';

            trigger OnValidate()
            var
                DOPaymentConnectionDetails: Record "DO Payment Connection Details";
            begin
                IF Active THEN BEGIN
                    IF NOT DOPaymentConnectionDetails.GET THEN
                        ERROR(Text001);
                    DOPaymentConnectionDetails.CALCFIELDS(UserName);
                    DOPaymentConnectionDetails.CALCFIELDS(Password);
                    IF (NOT DOPaymentConnectionDetails.UserName.HASVALUE) OR (NOT DOPaymentConnectionDetails.Password.HASVALUE) THEN
                        ERROR(Text001);
                END;
            end;
        }
        field(4; "Run in Test Mode"; Boolean)
        {
            Caption = 'Run in Test Mode';
        }
        field(5; "Service ID"; Guid)
        {
            Caption = 'Service ID';

            trigger OnLookup()
            begin
                //DOPaymentIntegrationMgt.SelectServiceId("Service ID");
            end;
        }
        field(6; Environment; Text[10])
        {
            Caption = 'Environment';
        }
        field(8; OrganizationId; Text[40])
        {
            Caption = 'OrganizationId';
        }
        field(9; ServiceGroupId; Text[40])
        {
            Caption = 'ServiceGroupId';
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

    trigger OnDelete()
    var
        DOPaymentConnectionDetails: Record "DO Payment Connection Details";
    begin
        DOPaymentConnectionDetails.DELETEALL;
    end;

    var
        Text001: Label 'You must complete the sign-up process and associate your Microsoft Dynamics ERP Services account with Microsoft Dynamics NAV before you can enable this feature.';
        Text004: Label 'http://go.microsoft.com/fwlink/?LinkId=106549&ServiceID=';

    [Scope('Internal')]
    procedure SignUp()
    begin
        //DOPaymentIntegrationMgt.ServiceBoarding;
    end;

    [Scope('Internal')]
    procedure ManageAccount()
    begin
        GET;
        HYPERLINK(Text004 + DELCHR(DELCHR(FORMAT("Service ID"), '=', '{'), '=', '}'));
    end;

    [Scope('Internal')]
    procedure CreateDefaultSetup()
    begin
        IF NOT GET THEN BEGIN
            INIT;
            Environment := 'PROD';
            INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure Disassociate()
    begin
        /*IF GET THEN
          DOPaymentIntegrationMgt.Disassociate
        ELSE
          ERROR(Text001);*/

    end;
}

