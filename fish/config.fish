set fish_greeting (date)

set -gx EDITOR nvim
set -gx SUDO_ASKPASS /usr/lib/ssh/x11-ssh-askpass

function fish_user_key_bindings
	fzf_key_bindings

    # See functions directory for the following
    bind \e\e sudope
    bind . expand_dots
end

function take --argument-names 'dirname'
    command mkdir $dirname; and cd $dirname
end

kitty + complete setup fish | source
abbr --add kssh 'kitty +kitten ssh'
abbr --add v nvim

# See functions directory for the following
install_git_abbr
colorman

alias d 'cd ~/prog/duma'
set -gx ERL_LIBS /home/ondrej/prog/duma/extlibs/rebar:/home/ondrej/prog/duma/extlibs/jiffy:/home/ondrej/prog/duma/extlibs/eredis:/home/ondrej/prog/duma/extlibs/ranch:/home/ondrej/prog/duma/extlibs/recon:/home/ondrej/prog/duma/extlibs/meck:/home/ondrej/prog/duma/extlibs/erlcapnp:/home/ondrej/prog/duma/extlibs/brod:/home/ondrej/prog/duma/extlibs/eflame:/home/ondrej/prog/duma/extlibs/brod/deps/supervisor3:/home/ondrej/prog/duma/extlibs/brod/deps/kafka_protocol:/home/ondrej/prog/duma/extlibs/brod/deps/snappyer:/home/ondrej/prog/duma/extlibs/raven-erlang:/home/ondrej/prog/duma/extlibs/msgpack:/home/ondrej/prog/duma/extlibs/otter_lib:/home/ondrej/prog/duma/extlibs/opentracing-erlang:/home/ondrej/prog/duma/apps/capnp:/home/ondrej/prog/duma/apps/bf:/home/ondrej/prog/duma/apps/blacklist:/home/ondrej/prog/duma/apps/bookie_accounts:/home/ondrej/prog/duma/apps/bookie_accounts_slave:/home/ondrej/prog/duma/apps/settle:/home/ondrej/prog/duma/apps/duma:/home/ondrej/prog/duma/apps/doctor:/home/ondrej/prog/duma/apps/forex:/home/ondrej/prog/duma/apps/forex_slave:/home/ondrej/prog/duma/apps/graphite_client:/home/ondrej/prog/duma/apps/hacks:/home/ondrej/prog/duma/apps/kafka_log:/home/ondrej/prog/duma/apps/ks:/home/ondrej/prog/duma/apps/locke_client:/home/ondrej/prog/duma/apps/logger:/home/ondrej/prog/duma/apps/logstash:/home/ondrej/prog/duma/apps/log_client:/home/ondrej/prog/duma/apps/log_server:/home/ondrej/prog/duma/apps/mir:/home/ondrej/prog/duma/apps/cartographer:/home/ondrej/prog/duma/apps/monitor:/home/ondrej/prog/duma/apps/name_servers:/home/ondrej/prog/duma/apps/names:/home/ondrej/prog/duma/apps/names_client:/home/ondrej/prog/duma/apps/neovm:/home/ondrej/prog/duma/apps/lantern:/home/ondrej/prog/duma/apps/psql:/home/ondrej/prog/duma/apps/qc:/home/ondrej/prog/duma/apps/report:/home/ondrej/prog/duma/apps/scraper:/home/ondrej/prog/duma/apps/spider:/home/ondrej/prog/duma/apps/sql:/home/ondrej/prog/duma/apps/stats:/home/ondrej/prog/duma/apps/testing:/home/ondrej/prog/duma/apps/tsar:/home/ondrej/prog/duma/apps/utils:/home/ondrej/prog/duma/apps/scraper_serv:/home/ondrej/prog/duma/apps/wc:/home/ondrej/prog/duma/apps/bq:/home/ondrej/prog/duma/apps/ubetu:/home/ondrej/prog/duma/apps/ubetu_listener:/home/ondrej/prog/duma/apps/checkin:/home/ondrej/prog/duma/apps/canceller:/home/ondrej/prog/duma/apps/commission:/home/ondrej/prog/duma/apps/pmm:/home/ondrej/prog/duma/apps/multicast:/home/ondrej/prog/duma/apps/bookie_registry:/home/ondrej/prog/duma/apps/bookie_registry_slave:/home/ondrej/prog/duma/apps/smusher:/home/ondrej/prog/duma/apps/order_watcher:/home/ondrej/prog/duma/apps/testing_mocks:/home/ondrej/prog/duma/apps/bulk_order_poller:/home/ondrej/prog/duma/apps/order_canceller:/home/ondrej/prog/duma/apps/position:/home/ondrej/prog/duma/apps/placement_tracker:/home/ondrej/prog/duma/apps/event_volume:/home/ondrej/prog/duma/apps/danger_watcher:/home/ondrej/prog/duma/apps/balance:/home/ondrej/prog/duma/apps/spy_booker
