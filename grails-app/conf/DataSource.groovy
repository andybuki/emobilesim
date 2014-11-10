dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {

    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
    cache.provider_class='org.hibernate.cache.EhCacheProvider'

}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "create-drop"
            //dbCreate = "update" //"create-drop"
            // dbCreate = "create-drop"
            driverClassName = "com.mysql.jdbc.Driver"
            url = "jdbc:mysql://localhost/emobilesim"
            dialect = "org.hibernate.dialect.MySQLDialect"
            username = "emobilesim"
            password = "emobilesim"
            pooled = true
            properties = {
                driverClassName = "com.mysql.jdbc.Driver"
                jmxEnabled = true
                maxActive = 500
                initialSize = 5
                minIdle = 5
                maxIdle = 25
                maxWait = 3153600000
                maxAge = 10 * 60000
                autoReconnect=true
                timeBetweenEvictionRunsMillis =1800000
                minEvictableIdleTimeMillis = 1800000
                validationQuery = "SELECT 1"
                validationQueryTimeout = 3
                validationInterval = 15000
                testOnBorrow = true
                testOnReturn = true
                testWhileIdle = true
                ignoreExceptionOnPreLoad = true
                abandonWhenPercentageFull = 100
                removeAbandonedTimeout=120
                removeAbandoned=true
                logAbandoned = false
                jdbcInterceptors = "ConnectionState"
                defaultTransactionIsolation = java.sql.Connection.TRANSACTION_READ_COMMITTED
                dbProperties {
                    autoReconnect=true
                    // truncation behaviour
                    jdbcCompliantTruncation=false
                    // mysql 0-date conversion
                    zeroDateTimeBehavior='convertToNull'
                    // Tomcat JDBC Pool's StatementCache is used instead, so disable mysql driver's cache
                    cachePrepStmts=false
                    cacheCallableStmts=false
                    // Tomcat JDBC Pool's StatementFinalizer keeps track
                    dontTrackOpenResources=true
                    // performance optimization: reduce number of SQLExceptions thrown in mysql driver code
                    holdResultsOpenOverStatementClose=true
                    // enable MySQL query cache - using server prep stmts will disable query caching
                    useServerPrepStmts=false
                    // metadata caching
                    cacheServerConfiguration=true
                    cacheResultSetMetadata=true
                    metadataCacheSize=100
                    // timeouts for TCP/IP
                    connectTimeout=15000
                    socketTimeout=120000
                    // timer tuning (disable)
                    maintainTimeStats=false
                    enableQueryTimeouts=false
                    // misc tuning
                    noDatetimeStringSync=true
                }
            }
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
        }
    }

    production {
        /*
        dataSource {
            dbCreate = "update"
            jndiName = "java:comp/env/jdbc/emobileDataSource"
        }
        */


        dataSource {
            dbCreate = "update" //"create-drop"
            driverClassName = "com.mysql.jdbc.Driver"
            dialect = org.hibernate.dialect.MySQLInnoDBDialect
            url = "jdbc:mysql://localhost/emobilesim1"
            username = "root"
            password = "reldb00"
            pooled = true
            properties = {
               maxActive = 500
               minEvictableIdleTimeMillis = 1800000
               timeBetweenEvictionRunsMillis = 1800000
               numTestsPerEvictionRun = 3
               testOnBorrow = true
               testWhileIdle = true
               testOnReturn = true
               validationQuery = "SELECT 1"
            }
        }

    }

    lnv {
        /*
        dataSource {
            dbCreate = "update"
            jndiName = "java:comp/env/jdbc/emobileDataSource"
        }
        */


        dataSource {
            dbCreate = "update" //"create-drop"
            driverClassName = "com.mysql.jdbc.Driver"
            url = "jdbc:mysql://mysql.sb.dfki.de/emobilsim"
            username = "efahrung_admin"
            password = "f498236e"
            pooled = true
            properties = {
                driverClassName = "com.mysql.jdbc.Driver"
                jmxEnabled = true
                maxActive = 100
                initialSize = 5
                minIdle = 5
                maxIdle = 25
                maxWait = 3153600000
                maxAge = 10 * 60000
                autoReconnect=true
                timeBetweenEvictionRunsMillis =1800000
                minEvictableIdleTimeMillis = 1800000
                validationQuery = "SELECT 1"
                validationQueryTimeout = 3
                validationInterval = 15000
                testOnBorrow = true
                testOnReturn = true
                testWhileIdle = true
                ignoreExceptionOnPreLoad = true
                abandonWhenPercentageFull = 100
                removeAbandonedTimeout=120
                removeAbandoned=true
                logAbandoned = false
                dbProperties {
                    autoReconnect=true
                    // truncation behaviour
                    jdbcCompliantTruncation=false
                    // mysql 0-date conversion
                    zeroDateTimeBehavior='convertToNull'
                    // Tomcat JDBC Pool's StatementCache is used instead, so disable mysql driver's cache
                    cachePrepStmts=false
                    cacheCallableStmts=false
                    // Tomcat JDBC Pool's StatementFinalizer keeps track
                    dontTrackOpenResources=true
                    // performance optimization: reduce number of SQLExceptions thrown in mysql driver code
                    holdResultsOpenOverStatementClose=true
                    // enable MySQL query cache - using server prep stmts will disable query caching
                    useServerPrepStmts=false
                    // metadata caching
                    cacheServerConfiguration=true
                    cacheResultSetMetadata=true
                    metadataCacheSize=100
                    // timeouts for TCP/IP
                    connectTimeout=15000
                    socketTimeout=120000
                    // timer tuning (disable)
                    maintainTimeStats=false
                    enableQueryTimeouts=false
                    // misc tuning
                    noDatetimeStringSync=true
                }

            }

        }

    }


}
