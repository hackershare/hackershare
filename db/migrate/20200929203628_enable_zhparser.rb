class EnableZhparser < ActiveRecord::Migration[6.0]
  def change
    enable_extension :zhparser
    execute(<<~SQL)
      CREATE TEXT SEARCH CONFIGURATION zh (PARSER = zhparser)
    SQL
    execute(<<~SQL)
      ALTER TEXT SEARCH CONFIGURATION zh ADD MAPPING FOR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z WITH simple
    SQL
  end
end
