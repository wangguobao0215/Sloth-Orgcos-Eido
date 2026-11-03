// OrgCOS Neo4j Constraint Definitions
// Source: T1 Kernel Design v1.0, Section 3

// Unique constraints for entity IDs
CREATE CONSTRAINT enterprise_id IF NOT EXISTS FOR (n:Enterprise) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT orgunit_id IF NOT EXISTS FOR (n:OrgUnit) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT role_id IF NOT EXISTS FOR (n:Role) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT person_id IF NOT EXISTS FOR (n:Person) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT customer_id IF NOT EXISTS FOR (n:Customer) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT product_id IF NOT EXISTS FOR (n:Product) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT partner_id IF NOT EXISTS FOR (n:Partner) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT competitor_id IF NOT EXISTS FOR (n:Competitor) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT market_id IF NOT EXISTS FOR (n:Market) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT capability_id IF NOT EXISTS FOR (n:Capability) REQUIRE n.id IS UNIQUE;

// Existence constraints for required properties
CREATE CONSTRAINT enterprise_name IF NOT EXISTS FOR (n:Enterprise) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT orgunit_name IF NOT EXISTS FOR (n:OrgUnit) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT role_title IF NOT EXISTS FOR (n:Role) REQUIRE n.title IS NOT NULL;
CREATE CONSTRAINT person_name IF NOT EXISTS FOR (n:Person) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT customer_name IF NOT EXISTS FOR (n:Customer) REQUIRE n.name IS NOT NULL;

// Node property type constraints
CREATE CONSTRAINT person_expertise IF NOT EXISTS FOR (n:Person) REQUIRE n.expertise_tags IS :: LIST<STRING>;
CREATE CONSTRAINT product_modules IF NOT EXISTS FOR (n:Product) REQUIRE n.module_list IS :: LIST<STRING>;
CREATE CONSTRAINT competitor_strengths IF NOT EXISTS FOR (n:Competitor) REQUIRE n.strengths IS :: LIST<STRING>;

// Index for governance queries
CREATE INDEX governance_confidence IF NOT EXISTS FOR (n) ON (n.confidence);
CREATE INDEX governance_valid_until IF NOT EXISTS FOR (n) ON (n.valid_until);
CREATE INDEX governance_owner IF NOT EXISTS FOR (n) ON (n.owner);
