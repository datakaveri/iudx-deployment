package iudx.data.ingestion.server.metering.util;

public class Constants {

  public static final String ID = "id";
  /* Errors */
  public static final String SUCCESS = "Success";
  public static final String FAILED = "Failed";
  public static final String DETAIL = "detail";
  public static final String TITLE = "title";
  public static final String RESULTS = "results";

  /* Database */
  public static final String QUERY_KEY = "query";
  public static final String TOTAL = "total";
  public static final String TYPE_KEY = "type";
  public static final String API = "api";
  public static final String USER_ID = "userid";
  public static final String WRITE_QUERY =
      "INSERT INTO ingestionauditingtable (id,api,userid,epochtime,resourceid,isotime,providerid) VALUES ('$1','$2','$3',$4,'$5','$6','$7')";
  public static final String MESSAGE = "message";
}
