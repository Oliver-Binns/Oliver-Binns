/**
 * Prints HTML with meta information for the current post-date/time and author.
 */
function oliver_posted_on() {
        // Let's get a nicely formatted string for the published date
        $time_string = '<time class="entry-date published updated" datetime="%1$s">%2$s</time>';
        if ( get_the_time( 'U' ) !== get_the_modified_time( 'U' ) ) {
                $time_string = '<time class="entry-date published" datetime="%1$s">%2$s</time><time class="updated" datetime="%3$s">%4$s</time>';
        }

        $time_string = sprintf( $time_string,
                esc_attr( get_the_date( 'c' ) ),
                esc_html( get_the_date() ),
                esc_attr( get_the_modified_date( 'c' ) ),
                esc_html( get_the_modified_date() )
        );

        // Wrap that in a link, and preface it with 'Posted on'
        $posted_on = sprintf(
                esc_html_x( 'Posted on %s', 'post date', 'lodestar' ),
                '<a href="' . esc_url( get_permalink() ) . '" rel="bookmark">' . $time_string . '</a>'
        );

        // Finally, let's write all of this to the page
        echo '<span class="posted-on">' . $posted_on . '</span>';
}
