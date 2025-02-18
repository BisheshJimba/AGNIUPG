table 50024 "Vehicle Attachment"
{
    // New Table Created for Storing Vehicle Related Attachments

    // LookupPageID = 50044;

    fields
    {
        field(1; "Serial No"; Code[20])
        {
        }
        field(2; Attachment; BLOB)
        {
        }
        field(3; Extension; Text[30])
        {
        }
        field(4; "Attachment Type"; Option)
        {
            OptionCaption = 'Pragyapan Patra,Commercial Invoice,Other,Job';
            OptionMembers = "Pragyapan Patra","Commercial Invoice",Other,Job;
        }
        field(5; AttachmentNo; Integer)
        {
            AutoIncrement = false;
        }
        field(6; "Date Imported"; Date)
        {
        }
        field(7; "Time Imported"; Time)
        {
        }
        field(8; "User ID"; Code[50])
        {
        }
        field(9; "File Name"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Serial No", AttachmentNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Txt001: Label 'Do you want to overwrite existing Attachment ?';
        Txt002: Label 'Import Attachment.';
        Txt003: Label 'Update Attachment.';
        FileName: Text[1024];
        ServerFileName: Text[1024];
        FileMgmt: Codeunit "File Management";
        ExtensionStart: Integer;
        TempBlob: Record TempBlob;
        Txt004: Label 'No Attachment In Current Document.';
        Txt005: Label 'Attachment File ''''%1'''' imported successfully.';
        Txt006: Label 'Do you want to delete the Attachment In %1?';
        VAttachment: Record "Vehicle Attachment";
        AttNo: Integer;

    procedure ImportAttachment(SerialNo: Code[20]; DocType: Integer)
    var
        AttachRecordRef: RecordRef;
    begin
        VAttachment.RESET;
        VAttachment.SETRANGE("Serial No", SerialNo);
        IF VAttachment.FINDLAST THEN
            AttNo := VAttachment.AttachmentNo + 1
        ELSE
            AttNo := 1;

        INIT;
        "Serial No" := SerialNo;
        AttachmentNo := AttNo;

        FileName := FileMgmt.BLOBImportWithFilter(TempBlob, Txt002, '', '*.pdf|', '*.pdf');

        IF FileName = '' THEN
            EXIT;

        Attachment := TempBlob.Blob;

        Extension := '.' + FileMgmt.GetExtension(FileName);
        "File Name" := FileMgmt.GetFileName(FileName);
        "Date Imported" := TODAY;
        "Time Imported" := TIME;
        "User ID" := USERID;
        "Attachment Type" := DocType;
        INSERT;

        IF Attachment.HASVALUE THEN
            MESSAGE(Txt005, FileName);
    end;

    procedure ExportAttachment(SerialNo: Code[20]; AttNo: Integer)
    var
        FileName: Text[1024];
        ServerFileName: Text[1024];
        FileMgmt: Codeunit "File Management";
    begin
        SETRANGE("Serial No", SerialNo);
        SETRANGE(AttachmentNo, AttNo);
        IF NOT FINDFIRST THEN
            ERROR(Txt004);

        CALCFIELDS(Attachment);

        IF NOT Attachment.HASVALUE THEN
            ERROR(Txt004);

        TempBlob.Blob := Attachment;
        FileMgmt.BLOBExport(TempBlob, FORMAT("File Name" + ''), TRUE);
    end;

    procedure UpdateAttachment(SerialNo: Code[20]; AttNo: Integer)
    begin
        SETRANGE("Serial No", SerialNo);
        SETRANGE(AttachmentNo, AttNo);

        CALCFIELDS(Attachment);
        IF NOT CONFIRM(Txt001) THEN
            EXIT;

        FileName := FileMgmt.BLOBImportWithFilter(TempBlob, Txt002, '', '*.*|', '*.*');

        IF FileName = '' THEN
            EXIT;

        Attachment := TempBlob.Blob;
        Extension := '.' + FileMgmt.GetExtension(FileName);

        MODIFY;

        IF Attachment.HASVALUE THEN
            MESSAGE(Txt005, FileName);
    end;

    procedure DeleteAttachment(SerialNo: Code[20]; AttNo: Integer)
    begin
        SETRANGE("Serial No", SerialNo);
        SETRANGE(AttachmentNo, AttNo);

        IF NOT FINDFIRST THEN
            ERROR(Txt004);

        CALCFIELDS(Attachment);

        IF Attachment.HASVALUE THEN
            IF CONFIRM(Txt006, FALSE, SerialNo) THEN
                DELETE;
    end;
}

