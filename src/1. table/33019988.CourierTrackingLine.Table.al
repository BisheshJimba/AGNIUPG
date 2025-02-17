table 33019988 "Courier Tracking Line"
{
    Caption = 'Courier Track. Line';

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Transfer,Return';
            OptionMembers = Transfer,Return;
            TableRelation = "Courier Tracking Header"."Document Type";
        }
        field(2; "Document No."; Code[20])
        {
            TableRelation = "Courier Tracking Header".No. WHERE(Document Type=FIELD(Document Type));
        }
        field(3;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(4;"POD No.";Code[20])
        {
        }
        field(5;"AWB No.";Code[20])
        {
        }
        field(6;"Packet No.";Code[20])
        {
            Description = 'Link with Item.';
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
                IF "Packet Type" = "Packet Type"::"Fixed Asset" THEN BEGIN
                  GlobalFixedAsset.RESET;
                  IF PAGE.RUNMODAL(0,GlobalFixedAsset) = ACTION::LookupOK THEN
                    VALIDATE("Packet No.",GlobalFixedAsset."No.");
                END ELSE IF "Packet Type" = "Packet Type"::Item THEN BEGIN
                  GlobalItem.RESET;
                  IF PAGE.RUNMODAL(0,GlobalItem) = ACTION::LookupOK THEN
                    VALIDATE("Packet No.",GlobalItem."No.");
                END;
            end;

            trigger OnValidate()
            begin
                IF "Packet Type" = "Packet Type"::"Fixed Asset" THEN BEGIN
                  GlobalFixedAsset.RESET;
                  GlobalFixedAsset.SETRANGE("No.","Packet No.");
                  IF GlobalFixedAsset.FIND('-') THEN
                    Description := GlobalFixedAsset.Description;
                END ELSE IF "Packet Type" = "Packet Type"::Item THEN BEGIN
                  GlobalItem.RESET;
                  GlobalItem.SETRANGE("No.","Packet No.");
                  IF GlobalItem.FIND('-') THEN
                    Description := GlobalItem.Description;
                END;
            end;
        }
        field(7;Description;Text[50])
        {
        }
        field(8;"Packet Type";Option)
        {
            Description = 'Have to consult with admin dept.';
            OptionCaption = 'Document,Item,Fixed Asset,Others';
            OptionMembers = Document,Item,"Fixed Asset",Others;
        }
        field(9;Weight;Decimal)
        {
        }
        field(10;Rate;Decimal)
        {

            trigger OnValidate()
            begin
                Amount := Rate * Quantity;
            end;
        }
        field(11;Amount;Decimal)
        {
        }
        field(12;"Unit of Measure";Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(13;Quantity;Decimal)
        {

            trigger OnValidate()
            begin
                "Quantity To Ship" := Quantity;
                "Quantity To Receive" := Quantity;

                IF "Document Type" = "Document Type"::Return THEN
                  "Quantity To Return" := Quantity;
            end;
        }
        field(14;"Quantity To Ship";Decimal)
        {
        }
        field(15;"Quantity To Receive";Decimal)
        {
        }
        field(16;"Quantity To Return";Decimal)
        {
        }
        field(17;Condition;Code[10])
        {
            Description = 'Only when receiving';
            TableRelation = "Reason Code".Code;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Text33019962: Label 'Cannot delete released document.';
    begin
        //Checking header for status.
        GlobalCourTrackHdr.RESET;
        GlobalCourTrackHdr.SETRANGE("Document Type","Document Type");
        GlobalCourTrackHdr.SETRANGE("No.","Document No.");
        IF GlobalCourTrackHdr.FIND('-') THEN BEGIN
          IF (GlobalCourTrackHdr.Status = GlobalCourTrackHdr.Status::Released) THEN
            ERROR(Text33019962);
        END;
    end;

    trigger OnInsert()
    var
        Text33019963: Label 'Document is released. Cannot insert new record.';
    begin
        //Checking header for status.
        GlobalCourTrackHdr.RESET;
        GlobalCourTrackHdr.SETRANGE("Document Type","Document Type");
        GlobalCourTrackHdr.SETRANGE("No.","Document No.");
        IF GlobalCourTrackHdr.FIND('-') THEN BEGIN
          IF (GlobalCourTrackHdr.Status = GlobalCourTrackHdr.Status::Released) THEN
            ERROR(Text33019963);
        END;
    end;

    trigger OnModify()
    var
        Text33019961: Label 'Cannot modify released document.';
    begin
        //Checking header for status.
        GlobalCourTrackHdr.RESET;
        GlobalCourTrackHdr.SETRANGE("Document Type","Document Type");
        GlobalCourTrackHdr.SETRANGE("No.","Document No.");
        IF GlobalCourTrackHdr.FIND('-') THEN BEGIN
          IF (GlobalCourTrackHdr.Status = GlobalCourTrackHdr.Status::Released) THEN
            ERROR(Text33019961);
        END;
    end;

    var
        GlobalCourTrackHdr: Record "33019987";
        GlobalFixedAsset: Record "5600";
        GlobalItem: Record "27";
}

