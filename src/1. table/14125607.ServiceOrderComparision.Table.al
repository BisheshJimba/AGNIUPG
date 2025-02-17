table 14125607 "Service Order Comparision"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Description = '//';
        }
        field(2; Type; Option)
        {
            OptionMembers = " ",Line,Header;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(7; "Posted Service Order No."; Code[20])
        {
            Description = '//order is same only';
        }
        field(50059; VIN; Code[20])
        {
        }
        field(70001; "Line Type"; Option)
        {
            Description = '//>>from here the history starts';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(70002; "No."; Code[20])
        {
            TableRelation = IF ("Line Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Line Type" = CONST(Item)) Item
            ELSE IF ("Line Type" = CONST(Labor)) Resource
            ELSE IF ("Line Type" = CONST("External Service")) "External Service"
            ELSE IF ("Line Type" = CONST(" ")) "Standard Text";
        }
        field(70003; Descrption; Text[100])
        {
        }
        field(70004; "Location Code"; Code[20])
        {
        }
        field(70005; Qunatity; Decimal)
        {
        }
        field(70006; "Line Amt. Inc VAT"; Decimal)
        {
            Description = '//>>ends for history';
        }
        field(70007; "Past Invoice"; Boolean)
        {
        }
        field(70008; "Vehicle Serial No."; Code[20])
        {
        }
        field(70009; "Vehicle Registration No."; Code[30])
        {
        }
        field(70010; "Posted By"; Code[50])
        {
        }
        field(70011; Status; Option)
        {
            OptionMembers = " ",Open,Closed;
        }
        field(70012; "File Name"; Text[200])
        {
        }
        field(70013; File; BLOB)
        {
            Compressed = false;
            SubType = Bitmap;
        }
        field(70014; "Incomming Entry No."; Integer)
        {
        }
        field(70015; "Posting Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", Type, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure getCurrentServiceLine(ServNo: Code[20])
    var
        ServLine: Record "Service Line EDMS";
        ServiceOrder: Record "Service Order Comparision";
        ServHdr: Record "Service Header EDMS";
        lineNo: Integer;
        ServiceOrder1: Record "Service Order Comparision";
        lineNo1: Integer;
    begin
        CLEAR(ServiceOrder);
        ServHdr.RESET;
        ServHdr.SETRANGE("No.", ServNo);
        IF ServHdr.FINDFIRST THEN;

        /*ServiceOrder1.RESET;
        ServiceOrder1.SETRANGE("Document No.",ServNo);
        IF ServiceOrder1.FINDSET THEN BEGIN
          REPEAT
            lineNo1 := ServiceOrder1."Line No.";
            IF lineNo1 <= ServiceOrder1."Line No." THEN
              lineNo := ServiceOrder1."Line No.";
            IF lineNo = 0 THEN
              lineNo := lineNo1;
        
            UNTIL ServiceOrder1.NEXT = 0;
         // lineNo := ServiceOrder1."Line No."
        END ELSE
          lineNo := 0;
          */

        lineNo := 0;
        ServiceOrder1.RESET;
        ServiceOrder1.SETRANGE("Document No.", ServNo);
        IF ServiceOrder1.FINDSET THEN
            REPEAT
                IF lineNo <= ServiceOrder1."Line No." THEN
                    lineNo := ServiceOrder1."Line No.";
            UNTIL ServiceOrder1.NEXT = 0;


        ServiceOrder.RESET;
        ServiceOrder.SETRANGE("Document No.", ServNo);
        ServiceOrder.SETRANGE(Type, ServiceOrder.Type::Header);
        IF NOT ServiceOrder.FINDFIRST THEN BEGIN
            lineNo += 10000;
            ServiceOrder.INIT;
            ServiceOrder."Document No." := ServNo;
            // ServiceOrder."No." := ServNo;
            ServiceOrder.Type := ServiceOrder.Type::Header;
            ServiceOrder.VIN := ServiceOrder.VIN;
            ServiceOrder."Line No." := lineNo;
            ServiceOrder."Posting Date" := TODAY;
            ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
            ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
            ServiceOrder.INSERT;
        END;


        /*ServiceOrder1.RESET;
        ServiceOrder1.SETRANGE("Document No.",ServNo);
        IF ServiceOrder1.FINDLAST THEN
          lineNo := ServiceOrder1."Line No."
        ELSE
          lineNo := 0;
          */
        ServLine.RESET;
        ServLine.SETRANGE("Document No.", ServNo);
        IF ServLine.FINDSET THEN
            REPEAT

                lineNo += 10000;
                ServiceOrder.RESET;
                ServiceOrder.SETRANGE("Document No.", ServNo);
                ServiceOrder.SETRANGE(Type, Type::Line);
                ServiceOrder.SETRANGE("No.", ServLine."No.");
                IF ServiceOrder.FINDFIRST THEN BEGIN
                    ServiceOrder.VIN := ServHdr.VIN;
                    ServiceOrder."Line Type" := ServLine.Type;
                    ServiceOrder."No." := ServLine."No.";
                    ServiceOrder.Descrption := ServLine.Description;
                    ServiceOrder.Qunatity := ServLine.Quantity;
                    ServiceOrder."Location Code" := ServLine."Location Code";
                    ServiceOrder."Line Amt. Inc VAT" := ServLine."Line Amount";
                    ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
                    ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
                    ServiceOrder.MODIFY;
                END ELSE BEGIN
                    ServiceOrder.INIT;
                    ServiceOrder."Document No." := ServNo;
                    ServiceOrder.VIN := ServHdr.VIN;
                    ServiceOrder."Line Type" := ServLine.Type;
                    ServiceOrder."No." := ServLine."No.";
                    ServiceOrder.Descrption := ServLine.Description;
                    ServiceOrder."Line No." := lineNo;
                    ServiceOrder.Qunatity := ServLine.Quantity;
                    ServiceOrder."Location Code" := ServLine."Location Code";
                    ServiceOrder."Line Amt. Inc VAT" := ServLine."Line Amount";
                    //ServiceOrder.Type := ServiceOrder.Type::"Line Order";
                    ServiceOrder.Type := ServiceOrder.Type::Line;
                    ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
                    ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
                    ServiceOrder.INSERT;
                END;
            UNTIL ServLine.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure createDirectory(oldPath: Text; NewDir: Text; var AttrDir: Text)
    var
        Directory: Text;
        FileMgt: Codeunit "File Management";
        PathHelper: DotNet Path;
        SystemDirectoryServer: DotNet Directory;
        DirectoryHelper: DotNet Directory;
    begin
        Directory := FileMgt.GetDirectoryName(oldPath);
        NewDir := DELCHR(NewDir, '=', '#%&*:<>?\/{|}~');
        IF NewDir <> '' THEN BEGIN
            Directory := PathHelper.Combine(Directory, NewDir);
            IF NOT SystemDirectoryServer.Exists(Directory) THEN
                DirectoryHelper.CreateDirectory(Directory);
        END;

        AttrDir := Directory;
    end;

    [Scope('Internal')]
    procedure downloadAttchment(IncEntry: Integer): Boolean
    var
        tempFile: Text;
        IncommingDoc: Record "Incoming Document";
    begin
        IncommingDoc.GET(IncEntry);
        IF IncommingDoc."File Name" <> '' THEN BEGIN
            tempFile := IncommingDoc."File Name";
            DOWNLOAD(IncommingDoc."File Name", 'Save as', '', '', tempFile);
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure deleteAttachment(IncENt: Integer): Boolean
    var
        IncommingDoc: Record "Incoming Document";
    begin
        IncommingDoc.GET(IncENt);
        IF IncommingDoc."File Name" <> '' THEN BEGIN
            ERASE(IncommingDoc."Document No.");
            IncommingDoc."File Name" := '';
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}

